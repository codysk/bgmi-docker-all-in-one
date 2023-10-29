#!/usr/bin/env python3
import os
from shutil import copy
from bgmi.config import cfg
from bgmi.lib.models import STATUS_DELETED, STATUS_UPDATING, Followed
from bgmi.script import ScriptRunner
from bgmi.utils import normalize_path

print(cfg.save_path)

def getBangumiList():
	
	# subscribe list
	data = Followed.get_all_followed(STATUS_DELETED, STATUS_UPDATING)

	# bgmi-scripts list
	runner = ScriptRunner()
	patch_list = runner.get_models_dict()
	for i in patch_list:
		i['cover'] = normalize_path(i['cover'])

	data.extend(patch_list)
	return data

def copyCover2BangumiDirectory(bangumi=None):
	if bangumi is None:
		return
	coverBase = os.path.join(cfg.save_path, 'cover')

	coverPath = os.path.join(coverBase, bangumi['cover'])
	bangumiDir = os.path.join(cfg.save_path, bangumi['name'])

	print("copy: %s -> %s" % (coverPath, bangumiDir))
	copy(coverPath, bangumiDir)

def main():
	bangumi_list = getBangumiList()
	for bangumi in bangumi_list:
		copyCover2BangumiDirectory(bangumi)
		pass
	pass

if __name__ == '__main__':
	main()
