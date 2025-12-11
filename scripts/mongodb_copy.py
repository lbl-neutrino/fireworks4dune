#!/usr/bin/env python3
"""
MongoDB Database Copy Script

Copies a database from one MongoDB instance to another.
Supports non-standard ports and different servers.
"""

import argparse
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure, OperationFailure
import sys


def connect_to_mongo(host, port, username=None, password=None, auth_db='admin'):
    """Establish connection to MongoDB instance."""
    try:
        if username and password:
            client = MongoClient(
                host=host,
                port=port,
                username=username,
                password=password,
                authSource=auth_db,
                serverSelectionTimeoutMS=5000
            )
        else:
            client = MongoClient(
                host=host,
                port=port,
                serverSelectionTimeoutMS=5000
            )
        
        # Test connection
        client.admin.command('ping')
        print(f"✓ Connected to MongoDB at {host}:{port}")
        return client
    
    except ConnectionFailure as e:
        print(f"✗ Failed to connect to {host}:{port}: {e}")
        sys.exit(1)


def copy_database(source_client, target_client, db_name, drop_existing=False):
    """Copy database from source to target MongoDB instance."""
    
    # Check if source database exists
    if db_name not in source_client.list_database_names():
        print(f"✗ Database '{db_name}' not found on source server")
        sys.exit(1)
    
    source_db = source_client[db_name]
    target_db = target_client[db_name]
    
    # Drop target database if requested
    if drop_existing:
        print(f"Dropping existing database '{db_name}' on target...")
        target_client.drop_database(db_name)
    
    # Get all collections
    collections = source_db.list_collection_names()
    print(f"\nFound {len(collections)} collections to copy")
    
    total_docs = 0
    
    for collection_name in collections:
        print(f"\nCopying collection: {collection_name}")
        
        source_coll = source_db[collection_name]
        target_coll = target_db[collection_name]
        
        # Get document count
        doc_count = source_coll.count_documents({})
        print(f"  Documents: {doc_count}")
        
        if doc_count == 0:
            continue
        
        # Copy documents in batches
        batch_size = 1000
        docs_copied = 0
        
        cursor = source_coll.find()
        batch = []
        
        for doc in cursor:
            batch.append(doc)
            
            if len(batch) >= batch_size:
                target_coll.insert_many(batch, ordered=False)
                docs_copied += len(batch)
                print(f"  Progress: {docs_copied}/{doc_count}", end='\r')
                batch = []
        
        # Insert remaining documents
        if batch:
            target_coll.insert_many(batch, ordered=False)
            docs_copied += len(batch)
        
        print(f"  ✓ Copied {docs_copied} documents")
        total_docs += docs_copied
        
        # Copy indexes
        indexes = list(source_coll.list_indexes())
        if len(indexes) > 1:  # More than just the default _id index
            print(f"  Copying {len(indexes)-1} indexes...")
            for index in indexes:
                if index['name'] != '_id_':
                    keys = list(index['key'].items())
                    options = {k: v for k, v in index.items() 
                             if k not in ['key', 'v', 'ns']}
                    try:
                        target_coll.create_index(keys, **options)
                    except OperationFailure as e:
                        print(f"  Warning: Could not create index {index['name']}: {e}")
    
    print(f"\n✓ Database copy complete! Total documents copied: {total_docs}")


def main():
    parser = argparse.ArgumentParser(
        description='Copy MongoDB database from one instance to another',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Basic copy without authentication
  python mongo_copy.py mydb --src-host source.example.com --dst-host target.example.com
  
  # Copy with non-standard ports
  python mongo_copy.py mydb --src-host 192.168.1.10 --src-port 27018 --dst-host 192.168.1.20 --dst-port 27019
  
  # Copy with authentication
  python mongo_copy.py mydb --src-host source.com --src-user admin --src-pass secret123 --dst-host target.com --dst-user admin --dst-pass secret456
  
  # Drop existing target database before copying
  python mongo_copy.py mydb --src-host source.com --dst-host target.com --drop
        """
    )
    
    parser.add_argument('database', help='Name of the database to copy')
    
    # Source server options
    parser.add_argument('--src-host', required=True, help='Source MongoDB host')
    parser.add_argument('--src-port', type=int, default=27017, help='Source MongoDB port (default: 27017)')
    parser.add_argument('--src-user', help='Source MongoDB username')
    parser.add_argument('--src-pass', help='Source MongoDB password')
    parser.add_argument('--src-auth-db', default='admin', help='Source authentication database (default: admin)')
    
    # Target server options
    parser.add_argument('--dst-host', required=True, help='Target MongoDB host')
    parser.add_argument('--dst-port', type=int, default=27017, help='Target MongoDB port (default: 27017)')
    parser.add_argument('--dst-user', help='Target MongoDB username')
    parser.add_argument('--dst-pass', help='Target MongoDB password')
    parser.add_argument('--dst-auth-db', default='admin', help='Target authentication database (default: admin)')
    
    # Options
    parser.add_argument('--drop', action='store_true', help='Drop target database before copying')
    
    args = parser.parse_args()
    
    print("MongoDB Database Copy Tool")
    print("=" * 50)
    
    # Connect to source
    print(f"\nConnecting to source: {args.src_host}:{args.src_port}")
    source_client = connect_to_mongo(
        args.src_host, 
        args.src_port,
        args.src_user,
        args.src_pass,
        args.src_auth_db
    )
    
    # Connect to target
    print(f"Connecting to target: {args.dst_host}:{args.dst_port}")
    target_client = connect_to_mongo(
        args.dst_host,
        args.dst_port,
        args.dst_user,
        args.dst_pass,
        args.dst_auth_db
    )
    
    # Copy database
    print(f"\nCopying database: {args.database}")
    copy_database(source_client, target_client, args.database, args.drop)
    
    # Close connections
    source_client.close()
    target_client.close()
    print("\nConnections closed.")


if __name__ == '__main__':
    main()