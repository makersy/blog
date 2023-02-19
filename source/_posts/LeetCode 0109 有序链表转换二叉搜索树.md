---
title: LeetCode 0109 有序链表转换二叉搜索树
date: 2018-12-13 23:27:23
tags:
- Java
- 二叉树
- 链表
- LeetCode

categories:
- 数据结构
- 二叉树
---
#### 题目
给定一个单链表，其中的元素按升序排序，将其转换为高度平衡的二叉搜索树。
<!-- more -->
本题中，一个高度平衡二叉树是指一个二叉树每个节点 的左右两个子树的高度差的绝对值不超过 1。
示例：

> 给定的有序链表： [-10, -3, 0, 5, 9],
>
> 一个可能的答案是：[0, -3, 9, -10, null, 5], 它可以表示下面这个高度平衡二叉搜索树：
> ```
>     0
>    / \
>  -3   9
>  /   /
> -10  5
> ```

#### 题解
这道题类似归并排序，需要每次都把链表分为尽可能等长的两部分，然后分别对这两部分再进行生成二叉树的操作。可以用快慢指针，具体实现是：设置快慢指针各一个，慢指针步进为1，快指针步进为2，循环条件是快指针不为空且其子节点不为空。这样快指针走的长度是慢的2倍，可以保证每次循环都找到了链表的中心节点（平衡二叉树需要找中心节点）。每次循环后链表被分为： <u>0-premid</u>、<u>slow</u>、<u>slow.next-最后一个</u> 这三部分。
Java代码如下：
```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution {
	 public TreeNode sortedListToBST(ListNode head) {
		 if( head==null ) return null;
		 if( head.next==null ) return new TreeNode(head.val);
		 ListNode slow = head;
		 ListNode fast = head;
		 ListNode premid = null;
		 while( fast!=null && fast.next!=null ) {
			 premid = slow;
			 slow = slow.next;
			 fast = fast.next.next;
		 }
		 premid.next = null;
		 TreeNode root = new TreeNode(slow.val);
		 root.left = sortedListToBST(head);
		 root.right = sortedListToBST(slow.next);
		 return root;
	 }
}
```