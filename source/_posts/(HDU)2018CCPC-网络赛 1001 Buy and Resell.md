---
title: 2018CCPC-网络赛 1001 Buy and Resell
date: 2018-08-27 22:19:25
tags:  
- 算法
- 队列
- 贪心
- C/C++

categories:  

- 算法
- 贪心

---
# Buy and Resell
> Time Limit: 2000/1000 MS (Java/Others)    Memory Limit: 65536/65536 K (Java/Others)
> Total Submission(s): 2282    Accepted Submission(s): 359
>
> <!-- more -->


**Problem Description**
> The Power Cube is used as a stash of Exotic Power. There are n cities numbered 1,2,…,n where allowed to trade it. The trading price of the Power Cube in the i-th city is ai dollars per cube. Noswal is a foxy businessman and wants to quietly make a fortune by buying and reselling Power Cubes. To avoid being discovered by the police, Noswal will go to the i-th city and choose exactly one of the following three options on the i-th day:
> 
> 1. spend ai dollars to buy a Power Cube
2. resell a Power Cube and get ai dollars if he has at least one Power Cube
3. do nothing
> 
> Obviously, Noswal can own more than one Power Cubes at the same time. After going to the n cities, he will go back home and stay away from the cops. He wants to know the maximum profit he can earn. In the meanwhile, to lower the risks, he wants to minimize the times of trading (include buy and sell) to get the maximum profit. Noswal is a foxy and successful businessman so you can assume that he has infinity money at the beginning.


**Input**
> There are multiple test cases. The first line of input contains a positive integer T (T≤250), indicating the number of test cases. For each test case:
The first line has an integer n. (1≤n≤105)
The second line has n integers a1,a2,…,an where ai means the trading price (buy or sell) of the Power Cube in the i-th city. (1≤ai≤109)
It is guaranteed that the sum of all n is no more than 5×105.


**Output**
> For each case, print one line with two integers —— the maximum profit and the minimum times of trading to get the maximum profit.


**Sample Input**
> 3
4
1 2 10 9
5
9 5 9 10 5
2
2 1


**Sample Output**
> 16 4
5 2
0 0

## 题意
有n个位置，每个位置有一个价格a[i]，按从1-n顺序经过每个位置，每个位置都可以进行三种操作之一且只能进行一次：1) 花a[i]元购买一个物品；2）卖掉一个手上的物品得到a[i]元； 3）什么也不做。  
假设金钱无限，初始没物品，身上可以装无限个物品，求走完所有城市后所能得到的最大利润和得到该最大利润所需的最少操作数。  
## 题解
低买高卖，此题可应用贪心的思想，每次遇到一个价格时，总是与前面的最低价进行“抵消”，这样利润最大。但是也许后面还有比这个价格更高的，所以需要“反悔”的机会，把错误时机卖出的损失挽回。因此优先队列（价格低标记值大先出队）代表已有物品，每到一个城市，先判断此地价格是不是比队列的最低价格高，是的话就可以将最低价格的物品卖掉了，再把差值加到利润上。然后最低价弹出，在队列里插入此地价格两个，分别以1和0标记（已经卖过一次，尚未卖过）。如此循环，假如后面有更高价想反悔，就把标记为1的错误卖出值弹出，队中标记为0的代表这个值现在是未被使用，可参与买卖。  
举个例子：样例中有“1 2 10 9”这个情况，首先花1元买物品，遇到2时我会把1给卖出，队里插入“2 1”“2 0”，利润为-1+2=1。后来又遇到10，2就属于贱卖当然不行，此时队里有两个2，让标记为1的出队，剩下的2的标记为0，代表没有被使用过，插入“10 1”“10 0”，此时利润值为1-2+10=9（跟1买10卖的利润是一样的）。下一个遇到9，此时队中最小为2，消之，利润计算为9-2+9=16。
至于操作次数计算就简单了，只需要每次在标记为0的价格出队时总次数+2即可。
以下为代码：
```C++
#include<bits/stdc++.h>
using namespace std;
typedef long long LL;
struct node{
  int v, s;   //v--价格，s--状态
  node(int a, int b):v(a), s(b){}
  //重载<运算符，使优先队列让v小的先出队，v相同则s大的先出队
  //优先队列默认把结构体按从大到小排序，重载<运算符使其按照自定义顺序排序
  bool operator<(const node &a) const{
    if( v==a.v ) return s<a.s;
    return v>a.v;
  }
};
int main() {
  int t;
  while( t-- ){
    int n;
    LL profit=0, cnt=0;
    scanf("%d", &n);
    priority_queue<node> que;
    for( int i=0; i<n; i++ ){
      int c;
      scanf("%d", &c);
      if( !que.empty() && que.top().v<c ){
        node tmp=que.top();
        profit=profit-tmp.v+c;
        if( tmp.s==0 ) cnt+=2;  //当前最小值之前没有买过，次数加2(以最小值买，以最大值卖)
        que.pop();
        que.push(node(c, 1));
        que.push(node(c, 0));
      }
      else{
        que.push(node(c, 0));
      }
    }
    printf("%lld %lld\n", profit, cnt);
  }

  return 0;
}

```