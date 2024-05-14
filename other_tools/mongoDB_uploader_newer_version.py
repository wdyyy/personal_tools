# -*- coding: UTF-8 -*-

# FileName     : table_uploader
# Author       : EastsunW eastsunw@foxmail.com
# Create at    : 2022-04-21 22:18
# Last Modified: 2022-04-21 22:18
# Modified By  : EastsunW
# -------------
# Description  : 上传数据到MongoDB的工具
# -------------


from json import JSONDecodeError
from json import load as json_load
from sys import exit

from click import Path as click_Path
from click import echo as click_echo
from click import group as click_group
from click import option as click_option
from click import argument as click_argument
from pandas import read_csv
from pymongo import MongoClient
from pymongo.collection import Collection

# region Utils


class ConfigFileFormatError(Exception):
    def __init__(self):
        self.message = "配置文件格式错误"

    def __str__(self):
        return self.message


class FileUploadFailedError(Exception):
    def __init__(self, collection, file):
        self.collection = collection
        self.file = file

    def __str__(self):
        return f"{self.collection}\t{self.file}\tFail"


def connect_database(host: str, port: int, database: str, username: str, password: str):
    """连接数据库

    Args:
        host (str): 数据库地址
        port (str): 数据库端口
        database (str): 数据库名称
        username (str): 用户名
        password (str): 密码

    Returns:
        _type_: 如果连接成功就返回连接对象，连接不成功就返回None
    """

    client = MongoClient(host=host, port=port, username=username, password=password, authSource=database)
    db_client = client[database]
    try:
        return db_client
    except Exception as e:
        click_echo(e)
        click_echo("连接失败，请检查配置文件是否完整")
        return None


def upload_data(collection: Collection, filepath: str, sep: str = "\t", clear: bool = False) -> None:
    if not filepath:
        click_echo("文件不存在")
        exit(0)
    try:
        if clear:
            collection.delete_many({})
        if filepath.endswith(".json"):
            collection.insert_many(json_load(open(filepath, "r")))
        else:
            data_frame = read_csv(filepath, sep=sep, low_memory=False)
            data_dict = data_frame.to_dict(orient="records")
            collection.insert_many(data_dict)
    except:
        raise FileUploadFailedError(
            collection=collection.full_name,
            file=filepath
        )
    else:
        click_echo(f'{collection.full_name}\t{filepath}\tSuccess')


def parse_config(config) -> dict:
    try:
        return json_load(open(config, "r"))
    except JSONDecodeError:
        raise ConfigFileFormatError
    except FileNotFoundError:
        click_echo("配置文件不存在，请使用以下命令生成一个: \n")
        click_echo("/home/wangdy/tools/uploader generate <配置文件路径(可选)>")
# endregion


@click_group()
def main():
    pass

# region 批量上传数据


@main.command("config", help="使用配置批量上传数据，直接将配置文件作为参数，默认为 ./config.json ")
@click_argument(
    "file",
    type=click_Path(
        exists=True, readable=True,
        file_okay=True, dir_okay=False,
        resolve_path=True
    ),
    required=True,
    default="config.json"
)
def by_config(file):
    config: dict = parse_config(file)
    connection = connect_database(
        host=config["Connection"]["host"],
        port=config["Connection"]["port"],
        database=config["Connection"]["database"],
        username=config["Connection"]["username"],
        password=config["Connection"]["password"],
    )
    if connection is not None:
        for work in config["Upload"]:
            try:
                upload_data(
                    collection=connection[work["collection"]],
                    filepath=work["file"],
                    sep=work["sep"],
                    clear=work["replace"]
                )
            except FileUploadFailedError as e:
                click_echo(e)
# endregion


# region 手动上传数据


@main.command("manual", help="进行手动数据上传（不推荐）")
@click_option(
    "-H", "--host",
    type=str, required=True,
    default="localhost", show_default=True,
    help="MongoDB的地址"
)
@click_option(
    "-P", "--port",
    type=int, required=True,
    default=30000, show_default=True,
    help="MongoDB的端口"
)
@click_option(
    "-d", "--database",
    type=str, required=True,
    prompt=True, prompt_required=True,
    help="MongoDB的数据库名"
)
@click_option(
    "-c", "--collection",
    type=str, required=True,
    prompt=True, prompt_required=True,
    help="MongoDB的集合名"
)
@click_option(
    "-u", "--username",
    type=str, required=True,
    prompt=True, prompt_required=True,
    help="MongoDB的用户名"
)
@click_option(
    "-p", "--password",
    type=str, required=True,
    prompt=True, prompt_required=True, hide_input=True,
    help="MongoDB的密码"
)
@click_option(
    "-f", "--file",
    type=click_Path(
        exists=True, readable=True,
        file_okay=True, dir_okay=False,
        resolve_path=True
    ), required=True,
    prompt=True, prompt_required=True,
    help="要上传的数据，表格数据或者JSON数据"
)
@click_option(
    "-r", "--replace",
    type=bool, is_flag=True, default=False,
    help="是否先清理已有的数据"
)
def manually(host: str, port: int, database: str, collection: str, username: str, password: str, file: str, replace: bool):
    # 连接数据库
    client = connect_database(host, port, database, username, password)
    if not client is None:
        my_collection = client[collection]
        upload_data(
            collection=my_collection,
            filepath=file,
            clear=replace
        )
# endregion


@main.command("generate")
@click_argument("config", type=click_Path(
    exists=False, readable=True,
    file_okay=True, dir_okay=False,
    resolve_path=True
), required=False, default="config.json")
def generate_config(config):
    click_echo("警告：将会覆盖同名文件!\n")
    with open(config, "wt") as output:
        output.write(
            """{
    "Connection": {
        "host"    : "localhost",
        "port"    : 30000,
        "database": "your_database",
        "username": "your_username",
        "password": "your_password"
    },
    "Upload": [
        {
            "collection": "your_collection1",
            "file"      : "your_file1_path",
            "replace"   : true,
            "sep"       : "\\t"
        },
        {
            "collection": "your_collection2",
            "file"      : "your_file2_path",
            "replace"   : true,
            "sep"       : "\\t"
        }
    ]
}
""")
    click_echo(f"配置模板：{config} 已生成，编辑此文件后，通过以下命令进行批量数据上传：\n")
    click_echo(f"/home/wangdy/tools/dist/uploader config {config}")
    exit(0)


if __name__ == "__main__":
    main()  # type: ignore
