---
title: LeetCode 0050 Pow(x,n)
date: 2018-12-23 22:44:48
tags:
- LeetCode
- 算法
- Java

categories:
- 算法
---

#### 题目
实现 pow(x, n) ，即计算 x 的 n 次幂函数。

<!-- more -->

示例 1:
> 输入: 2.00000, 10
> 输出: 1024.00000

示例 2:
> 输入: 2.10000, 3
> 输出: 9.26100

示例 3:
>输入: 2.00000, -2
>输出: 0.25000

**解释**: 2<sup>-2</sup> = 1/2<sup>2</sup> = 1/4 = 0.25
**说明**:
- -100.0 < x < 100.0
- n 是 32 位有符号整数，其数值范围是 [−2<sup>31</sup>, 2<sup>31 </sup>− 1] 。

#### 题解
用的递归法，log n
```java
class Solution {
    public double myPow(double x, int n) {
    	boolean isNagetive = false;
    	if( n<0 ) {
    		n = -n;
    		isNagetive = true;
    	}
    	if( isNagetive ) {
    		return 1/pow(x, n);
    	}else {
    		return pow(x, n);
    	}
    }
    public static double pow(double x, int n) {
    	double res = 1.0;
		if( n==0 ) {
			return 1.0;
		}else if( n==1 ) {
			return x;
		}else if( n%2==0 ) {
			res = pow(x*x, n/2);
		}else{
			res = pow(x*x, n/2) * x;
		}
		return res;
	}
}
```