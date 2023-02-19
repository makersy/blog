---
title: LeetCode 0102-二叉树的层次遍历
date: 2018-12-07 20:56:26
tags:
- Java
- 数据结构
- 二叉树
- LeetCode
categories:
- 数据结构
- 二叉树
---
#### 题目
给定一个二叉树，返回其按层次遍历的节点值。 （即逐层地，从左到右访问所有节点）。
<!-- more -->
例如:
给定二叉树: [3,9,20,null,null,15,7],
​    ![](https://img-blog.csdnimg.cn/20181207210208562.png)

返回其层次遍历结果：
[
  [3],
  [9,20],
  [15,7]
]
#### 题解
我的思路是每行的节点都从左到右用一个队列或链表来存储，每次取队列头部并弹出。如果该节点有非空的后代节点则再加入队列，直到队列为空时停止。
代码如下:  
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
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> res=new LinkedList<>();
        LinkedList<TreeNode> queue=new LinkedList<TreeNode>();
        if(root==null) return res;
        queue.offer(root);
        while(!queue.isEmpty()){
            int size=queue.size();
            List<Integer> subres=new LinkedList<>();
            for(int i=0;i<size;i++){
                TreeNode tmp=queue.pop();
                subres.add(tmp.val);
                if(tmp.left!=null)
                    queue.offer(tmp.left);
                if(tmp.right!=null)
                    queue.offer(tmp.right);
            }
            res.add(subres);
        }
        return res;
    }
}
```
耗时最少的是用递归法做的  
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
    //递归实现
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> res=new ArrayList<>();
        if(root==null)  return res;
        recursionLevelOrder(root,0,res);
        return res;
    }
    private void recursionLevelOrder(TreeNode root,int level,List<List<Integer>> res){
        if(root==null) return;
        if(res.size()==level){
            List<Integer> subres=new ArrayList<>();
            subres.add(root.val);
            res.add(subres);
        }else{
            res.get(level).add(root.val);
        }
        recursionLevelOrder(root.left,level+1,res);
        recursionLevelOrder(root.right,level+1,res);
    }
}
```
