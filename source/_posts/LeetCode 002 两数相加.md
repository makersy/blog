---
title: LeetCode 002-两数相加
date: 2018-11-29 22:34:38  
categories: 
- 算法
- 数论
tags:  
- 算法
- Java
- LeetCode
---
一道很简单的题，但是因为空指针的判别耗了很长时间...
<!-- more -->

#### 题目

> 给出两个 非空 的链表用来表示两个非负的整数。其中，它们各自的位数是按照 逆序 的方式存储的，并且它们的每个节点只能存储 一位 数字。
如果，我们将这两个数相加起来，则会返回一个新的链表来表示它们的和。
您可以假设除了数字 0 之外，这两个数都不会以 0 开头。

**示例**  
> 输入：(2 -> 4 -> 3) + (5 -> 6 -> 4)
输出：7 -> 0 -> 8
原因：342 + 465 = 807  

#### 代码  
我的代码(虽然过了但是耗时多)
```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        ListNode now = new ListNode(0);
        ListNode res = now;
        while( l1!=null || l2!=null ){
            boolean flag=false;
            int sum = 0;
            if(l1==null){
                sum += 0;
            } else{
                sum += l1.val;
                if( l1.next==null ) l1=null;
                else {
                    l1=l1.next;   
                    flag=true;
                }
            }
            if(l2==null){
                sum += 0;
            } else {
                sum += l2.val;
                if( l2.next==null) l2=null;
                else {
                    l2=l2.next;
                    flag=true;
                }
            }
            now.val += sum;
            if( now.val<10 ){
                if( flag )
                    now.next = new ListNode(0);
            }
            else{
                now.next = new ListNode(now.val/10);
                now.val %= 10;
            }
            now = now.next;
        }
        
        return res;
    }
}
```
官方题解  
```java
public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
    ListNode dummyHead = new ListNode(0);
    ListNode p = l1, q = l2, curr = dummyHead;
    int carry = 0;
    while (p != null || q != null) {
        int x = (p != null) ? p.val : 0;
        int y = (q != null) ? q.val : 0;
        int sum = carry + x + y;
        carry = sum / 10;
        curr.next = new ListNode(sum % 10);
        curr = curr.next;
        if (p != null) p = p.next;
        if (q != null) q = q.next;
    }
    if (carry > 0) {
        curr.next = new ListNode(carry);
    }
    return dummyHead.next;
}
```

我没想到一个carry用两次，可以放在下一个循环继续用。