---
title: LeetCode 951 翻转二叉树
date: 2018-12-08 18:33:21
tags: 
- 二叉树
- 数据结构
- Java
- LeetCode
categories:
- 数据结构
- 二叉树
---

#### 题目

我们可以为二叉树 T 定义一个翻转操作，如下所示：选择任意节点，然后交换它的左子树和右子树。

只要经过一定次数的翻转操作后，能使 X 等于 Y，我们就称二叉树 X 翻转等价于二叉树 Y。

编写一个判断两个二叉树是否是翻转等价的函数。这些树由根节点 root1 和 root2 给出。
<!-- more -->
 

示例：

> 输入：root1 = [1,2,3,4,5,6,null,null,null,7,8], root2 = [1,3,2,null,6,4,5,null,null,null,null,8,7]
> 输出：true
> 解释：We flipped at nodes with values 1, 3, and 5.


提示：
每棵树最多有 100 个节点。
每棵树中的每个值都是唯一的、在 [0, 99] 范围内的整数。

#### 题解
先说一句，我没写出来。看到这个题我首先想的是怎么实现将某些节点交换左右子节点，而某些不换，从而判断两棵树是否相等。于是写了交换子节点的函数和判断两棵树是否相等的函数。且不说可行性，光O(n)就够我喝一壶的。
然后我看了下[网上大佬的题解](https://blog.csdn.net/u011732358/article/details/84790975)才懂。
我的代码理解都写在注释里。。

```java
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
    public boolean flipEquiv(TreeNode root1, TreeNode root2) {
    	//若有一个或两个为空，返回两节点是否相等。具体结果是：若均为空，返回true；若一个为空，返回false
        if(root1 == null || root2 == null){
            return root1 == root2;
        }
        //若两节点的值都不相等，那么自然树也不相等
        if(root1.val != root2.val){
            return false;
        }
        /*
        分别比较root1和root2的：左左、右右、左右、右左。
        若是可以通过交换子节点来使两根节点下的树相等，
        那么将这两个根节点的四个子节点顺序进行排列组合，
        若有一种情况下是两边相等,那么就可以通过交换而得；否则就不可以。
        */
        return flipEquiv(root1.left, root2.left) && flipEquiv(root1.right, root2.right) 
        || flipEquiv(root1.left, root2.right) && flipEquiv(root1.right, root2.left);
    }
}

```