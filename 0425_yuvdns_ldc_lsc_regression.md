# 0425-YUVDNS&LDC&LSC验证

0425环境下YUVDNS、LDC、LSC验证均在`/net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0425`目录下

0425测试环境：`/net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0425/default`

测试所用图片统一存放在`/net/dellr940d/export/ybfan2/hezx/ImageSet`文件夹下

## 目录结构与测试步骤

#### YUVDNS（路径：`/net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0425/yuvdns`）

> filelist文件夹：
>
> `./auto_config`
>
> 测试caselist：
>
> `./cases_name_yuvdns.txt`
>
> copy脚本（复制不同case）：
>
> `./copy_cases_yuvdns.sh`
> 
> config脚本（配置参数）：
>
> `./config_cases_yuvdns.sh`

> * 将当前环境测试文件放置路径下并更名为yuvdns_bypass
>
> ```text
> cp -r /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0425/default /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0425/yuvdns
> mv default yuvdns_bypass
> ```
>
> * 根据caselist复制不同命名文件夹
>
>  ```text
>   bash copy_cases_yuvdns.sh
>  ```
>
> * 配置各case参数
>  ```text
>  bash config_cases_yuvdns.sh
>  ```
>
> * 对每个case进行单独仿真测试
> ```text
> cd case名字/vmodel/sim
> source sourceme
> make
> ```

#### LDC（路径：`/net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0425/ldc`）

> filelist文件夹：
>
> `./auto_config`
>
> 测试caselist：
>
> `./cases_name_ldc.txt`
>
> copy脚本（复制不同case）：
>
> `./copy_cases_ldc.sh`
> 
> config脚本（配置参数）：
>
> `./config_cases_ldc.sh`

> * 将当前环境测试文件放置路径下并更名为ldc_bypass
>
> ```text
> cp -r /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0425/default /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0425/ldc
> mv default ldc_bypass
> ```
>
> * 根据caselist复制不同命名文件夹
>
>  ```text
>   bash copy_cases_ldc.sh
>  ```
>
> * 配置各case参数
>  ```text
>  bash config_cases_ldc.sh
>  ```
>
> * 对每个case进行单独仿真测试
> ```text
> cd case名字/vmodel/sim
> source sourceme
> make
> ```

#### LSC（路径：`/net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0425/lsc`）

> filelist文件夹：
>
> `./auto_config`
>
> 测试caselist：
>
> `./cases_name_lsc.txt`
>
> copy脚本（复制不同case）：
>
> `./copy_cases_lsc.sh`
> 
> config脚本（配置参数）：
>
> `./config_cases_lsc.sh`

> * 将当前环境测试文件放置路径下并更名为lsc_bypass
>
> ```text
> cp -r /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0425/default /net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0425/lsc
> mv default lsc_bypass
> ```
>
> * 根据caselist复制不同命名文件夹
>
>  ```text
>   bash copy_cases_lsc.sh
>  ```
>
> * 配置各case参数与lut
>  ```text
>  bash config_cases_lsc.sh
>  ```
>
> * 对每个case进行单独仿真测试
> ```text
> cd case名字/vmodel/sim
> source sourceme
> make
> ```

