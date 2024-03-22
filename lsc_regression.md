# LSC 验证

##  1. 复制最新仿真环境和脚本文件到 0319/lsc文件夹下

`mkdir  /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0319`

`mkdir  /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0319/lsc`

`cp -r  /net/dellr940d/export/ybfan2/isp_hls/sim_multi/tmp_storage/0319 /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0319/lsc`

`mv 0139 lsc_bypass`

 将仿真环境中输入图像删除
`rm -r Image/input/*`

复制配置bash脚本

`cd /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0319/lsc`

`cp /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0315/lsc/cases_name.txt . `

`cp /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0315/lsc/config_cases.sh . `

`cp /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0315/lsc/copy_cases.sh . `

`cp /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0315/lsc/lut_cases.sh . `

`cp -r /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0315/lsc/auto_lsc_config . `

把copy_cases.sh第4行source_folder路径修改为当前文件夹下lsc_bypass文件夹路径


## 2. 配置Cases参数
复制Cases

`bash copy_cases.sh`

配置Config

`bash config_cases.sh`

配置Lut

`bash lut_cases.sh`

ps. 最后需单独手动配置lsc_bypass的参数

## 3. 运行仿真

进入各个Case下的sim路径

`source sourceme`

`make`
