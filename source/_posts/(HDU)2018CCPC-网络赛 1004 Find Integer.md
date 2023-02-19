---
title: (HDU)2018CCPC - 网络赛 1004 Find Integer  
date: 2018-08-25 23:45:46  
tags: 
- 算法  
- C/C++
- 数论  

categories:  
- 算法
- 数论  

mathjax: true  

---
# Find Integer  
> Time Limit: 2000/1000 MS (Java/Others) Memory Limit: 65536/65536 K (Java/Others)Total Submission(s): 0 Accepted Submission(s): 0Special Judge  

<!-- more -->
**Problem Description**

> people in USSS love math very much, and there is a famous math problem .
give you two integers n,a,you are required to find 2 integers b,c such that an+bn=cn.

**Input**

>one line contains one integer T;(1≤T≤1000000)
next T lines contains two integers n,a;(0≤n≤1000,000,000,3≤a≤40000)

**Output**

>print two integers b,c if b,c exits;(1≤b,c≤1000,000,000);
else print two integers -1 -1 instead.

**Sample Input**
> 1 2 3

**Sample Output**
> 4 5

## 题解  
本题给出一个[费马大定理](https://baike.baidu.com/item/%E8%B4%B9%E9%A9%AC%E5%A4%A7%E5%AE%9A%E7%90%86/80363?fr=aladdin)的表达式 —— $a^n+b^n=c^n,(a,b,c) \in Z$。 题目意思是给定该公式中的a和n，求满足公式的b和c并输出，若不存在满足公式的b和c，则输出"-1 -1"。所以当n>2或n==0时输出"-1 -1"；当n=1时输出满足方程的第一组解：1 a+1；当n=2时输出勾股数。  
**求勾股数**：这种前n项固定的情况一般可以采用打表法。三层循环肯定是不行的，这么大数据量肯定tle。$a^2=c^2-b^2=(c+b)(c-b)$。令$x=c+b,y=c-b$，于是$a^2=xy$。从x着手，当满足a<sup>2</sup>可以整除x时就可以求出符合条件的b，c。  
代码如下：
```C++
#include<bits/stdc++.h>
using namespace std;
#define ll long long

struct node{
    ll b,c;
}gg[40007];

void init(){
    memset(gg, 0, sizeof(gg));
    for( ll i=3; i<=40000; i++ ){
        for( ll j=1; j<i; j++ ){
            if( i*i%j==0 ){   //若a^2可以整除(c+b),则此式成立
                ll x = j;
                ll y = i*i/j;
                if( (y-x)%2==0 ){   //若b为整数,则c也是整数
                    gg[i].c=(x+y)/2;
                    gg[i].b=(y-x)/2;
                    break;
                }
            }
        }
    }
}
int main()
{
    init();
    int t;
    scanf("%d", &t);
    while( t-- ){
        ll a, n;
        scanf("%lld%lld", &n, &a);
        if( n>2 || n==0 ){
            printf("-1 -1\n");
            continue;
        }
        else if( n==1 ){
            printf("1 %lld\n", a+1);
            continue;
        }
        else{
            if( gg[a].b ){
                printf("%lld %lld\n", gg[a].b, gg[a].c);
            }
            else
                printf("-1 -1\n");
        }

    }
    return 0;
}
```
