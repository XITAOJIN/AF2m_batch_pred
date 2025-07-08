#!/bin/bash
#设置要处理的文件夹路径
result_dir="./"
#遍历文件夹中的所有子文件夹
for dir in ${result_dir}/*; do
    # 如果是目录则处理
    if [ -d "${dir}" ]; then
        #提取目录名作为结果的名称
        result_name=$(basename ${dir})
        #假设每个目录下的结果保存在ranking_debug.json中
        result_file="${dir}/ranking_debug.json"
        #使用jq命令找出json文件中iptm+ptm对象中的最高得分
		if [ -f "$result_file" ]; then
			max_score=$(jq -r '.["iptm+ptm"] | map(tonumber) | max' "$result_file")
			#打印结果名称和对应的最高得分
			echo "${result_name}: ${max_score}" >> result.txt
		else
			echo "$result_file不存在"
		fi
    fi
done
