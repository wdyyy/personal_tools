#! /home/wangdy/miniconda3/bin/python
# -*- coding: UTF-8 -*-

# FileName     : mongo_uploader
# Author       : EastsunW eastsunw@foxmail.com
# Create at    : 2022-04-18 20:34
# Last Modified: 2022-04-18 20:34
# Modified By  : EastsunW
# -------------
# Description  : 将你的表格导入mongodb的工具
# -------------

import argparse
import sys
import time
import pymongo
import pandas as pd

def getOptions():
    parser = argparse.ArgumentParser(
        add_help    = True,
        usage       = "%(prog)s <options> <arguments>'",
        description = "将你的制表符分割的文件上传到mongodb的工具, 使用前请确保你的版本以及登录信息正确"
    )
    parser.add_argument(
        "-h", "--host",
        type     = str,
        required = False,
        default  = "localhost",
        action   = "store",
        dest     = "hostname",
        help     = "The hostname of your connection, default localhost"
    )
    parser.add_argument(
        "-p", "--port",
        type     = int,
        required = False,
        default  = 30000,
        action   = "store",
        dest     = "port",
        help     = "The port of your connection, default 30000"
    )
    parser.add_argument(
        "-u", "--username",
        type     = str,
        required = True,
        action   = "store",
        dest     = "username",
        help     = "The username of MongoDB"
    )
    parser.add_argument(
        "-p", "--password",
        type     = str,
        required = True,
        action   = "store",
        dest     = "password",
        help     = "The password of this user"
    )
    parser.add_argument(
        "-d", "--database",
        type     = str,
        required = True,
        action   = "store",
        dest     = "database",
        help     = "The name of your database"
    )
    parser.add_argument(
        "-c", "--collection",
        type     = str,
        required = True,
        action   = "store",
        dest     = "collection",
        help     = "The name of collection"
    )
    parser.add_argument(
        "-f", "--filepath",
        type     = str,
        required = True,
        action   = "store",
        dest     = "filepath",
        help     = "The file path of your table"
    )
    try:
        parser.parse_args()
    except:
        parser.print_help()
        exit(1)
    else:
        return(parser.parse_args())

#FUNC 判断数据库是否存在
def find_database(database: str, connection: pymongo.MongoClient) -> bool:
    if database in connection.list_database_names():
        print("已找到数据库: " + str(database))
        return True
    else:
        print("数据库" + str(database) + "不存在")
        return False

#FUNC 判断集合是否存在, 不存在就创建一个, 存在就清空数据
def find_collection(database: pymongo.MongoClient, collection: str) -> bool:
    if collection in database.list_collection_names():
        print("集合" + str(collection) + "已存在，继续操作会覆盖已有的集合，5秒后执行，请及时终止程序！")
        count = 3
        for i in range(count):
            print(str(count - i))
            time.sleep(1)
        return(True)
    else:
        print("集合" + str(collection) + "不存在，将会创建一个新的集合，5秒后执行")
        count = 3
        for i in range(count):
            print(str(count - i))
            time.sleep(1)
        return(False)

#FUNC 向集合写入数据
def insert_data(filepath, collection):
    table = pd.read_table(filepath)
    collection.insert_many(table.to_dict("records"))
    print("所有数据成功导入")

def main():
    options = getOptions()

    # 与mongoDB的连接
    client = pymongo.MongoClient(
        host       = options.hostname,
        port       = options.port,
        username   = options.username,
        password   = options.password,
        authSource = options.database
    )

    # 判断是否登录成功
    try:
        client.list_database_names()
    except pymongo.OperationFailure:
        print("登录失败, 请检查你的pymongo版本, 登录地址, 用户名和密码, 数据库名字等信息是否正确")
        sys.exit(1)

    # 判断数据库存在
    if find_database(options.database, client):
        # 数据库存在, 继续寻找集合
        myDatabase = client[options.database]
        # 集合存在, 清除所有数据后插入数据
        if find_collection(myDatabase, options.collection):
            myCollection = myDatabase[options.collection]
            myCollection.delete_many({})
            print("collection: ", options.collection, " 内的数据已经全部清除，耗子尾汁！")
            insert_data(options.filepath, myCollection)
        # 集合不存在, 创建一个集合后插入数据
        else:
            myCollection = myDatabase[options.collection]
            print("将创建一个名叫", options.collection, "的集合")
            insert_data(options.filepath, myCollection)
    else:
        print("数据库不存在，尝试创建一个")
        try:
            myDatabase = client[options.database]
            myCollection = myDatabase[options.collection]
            print("将创建一个名叫", options.collection, "的集合")
            insert_data(options.filepath, myCollection)
        except:
            print("出错了，请尝试手动创建数据库")
            sys.exit(1)
        else:
            print("导入成功")

if __name__=="__main__":
    main()
