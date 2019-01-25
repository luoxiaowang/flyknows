title: oracle递归
date: 2014-09-16 21:35:54
categories: 乱七八糟
tags: [乱七八糟]
---
本文主要介绍如何使用sql去进行递归查询。
<!--more-->
使用java去写一个递归遍历也不是太难，但是oracle sql里面却有更加简单的方法去实现。
例如：通过组别id递归查询组别下的所有员工
```sql
select * from (select * 
	from t_common_group t
	start with t.id = '001'
	CONNECT BY PRIOR t.id=t.parent_id) t2
	join t_common_agent t3 on t2.id = t3.group_id
where t3.state = 'INSERVICE' and t2.enable_flag='Y'
```
首先通过组别id用CONNECT关联父级id去遍历所有的组别，然后关联员工表获取该组别下的所有员工