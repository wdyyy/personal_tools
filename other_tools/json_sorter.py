# -*- coding: UTF-8 -*-

# FileName     : json排序
# Author       : EastsunW eastsunw@foxmail.com
# Create at    : 2022-11-07 20:51
# Last Modified: 2022-11-07 20:51
# Modified By  : EastsunW
# -------------
# Description  : Sort json
# -------------

import json
import sys

input_json = sys.argv[1]
output_json = sys.argv[2]

with open(input_json, "rt", encoding="utf-8") as setting_file:
    json_obj = json.load(setting_file)

sorted_dict = dict(sorted(json_obj.items(), key=lambda x: x[0]))

with open(output_json, "wt", encoding="utf-8") as output_file:
    json.dump(sorted_dict, output_file)
