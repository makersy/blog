---
title: 常见七大排序的Java实现
date: 2019-03-14 22:43:18
tags: 
- Java
- 排序
- 算法  


categories:
- 算法
- 排序

---

之前学习C语言时学过各类基础排序，现在用Java来再回顾一遍。这一篇主要是写一下规范的代码。

<!-- more -->

#### 一、排序相关的基本概念
  排序其实是一个相当大的概念，主要分为两类：内部排序和外部排序。而我们通常所说的各种排序算法其实指的是内部排序算法。内部排序是基于内存的，整个排序过程都是在内存中完成的，而外部排序指的是由于数据量太大，内存不能完全容纳，排序的时候需要借助外存才能完成（常常是某一部分已经计算过的数据移出内存让另一部分未被计算的数据进入内存）。而本篇文章将主要介绍内部排序中的几种常用排序算法：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190403193941184.png)
为了测试方便，我定义了生成随机数组的Const类和打印输出的print函数。Const类如下：

```java
public class Const {
    public int a[] = new int[50];

    public Const(){
        Random random = new Random();
        for( int i=0; i<a.length; i++ ){
            a[i] = random.nextInt(100);
        }
    }
}
```
#### 二、插入类排序
##### 1.直接插入
插入类排序算法的核心思想是，在一个有序的集合中，我们将当前值插入到适合位置上，使得插入结束之后整个集合依然是有序的。代码如下：
```java
/**
     * 插入排序
     * @param array
     */
    public static void InsertSort(int[] array){
        int i, j, key;
        for( i=1; i<array.length; i++ ){
            key = array[i];
            j = i - 1;
            //取当前位置值，与已经排序好的那一部分由大到小进行比较，将其挪到正确的位置
            while ( j>=0 && key<array[j] ){
                array[j+1] = array[j];
                j--;
            }
            array[j+1] = key;//在正确的位置插入key值
        }
        print(array);
    }
```

##### 2、二分插入
原理是二分查找到合适位置再进行插入。
```java
/**
     * 二分插入排序
     * @param array
     */
    public static void halfInsertSort(int[] array){
        for( int i=1; i<array.length; i++ ){
            int mid, low, high, key;
            low = 0;  high = i-1;
            key = array[i];
            //这个循环之后，要插入的地方为low
            while ( low<=high ){
                mid = (low+high)/2;
                if( key==array[mid] ){
                    low = mid;
                    break;
                }else if( key>array[mid] ){
                    low = mid + 1;
                }else{
                    high = mid - 1;
                }
            }
            //将已排序部分low之后的都向后移动一位
            for( int k=i-1; k>=low; k-- ){
                array[k+1] = array[k];
            }
            array[low] = key;
        }
        print(array);
    }
```

##### 3、希尔排序
希尔排序算法使用一个距离增量来切分子序列，使每个子序列都有序。当距离增量变小的时候，序列的个数也会变少，但是这些子序列的内部都基本有序，当对他们进行直接插入排序的时候会使得效率变高。一旦距离增量减少为1，那么子序列的个数也将减少为1，也就是我们的原序列，而此时的序列内部基本有序，最后执行一次直接插入排序完成整个排序操作。
```java
/**
     * 希尔排序
     * @param array
     */
    public static void shellSort(int[] array){
        int len = array.length;
        int step = len/2;//步长
        while( step>0 ){
            for( int i=step; i<len; i++ ){
                int j = i;
                //while循环 --对由步长分成的各数组进行直接插入排序
                while ( j>=step && array[j]<array[j-step] ){
                    int temp = array[j];
                    array[j] = array[j-step];
                    array[j-step] = temp;
                    j -= step;
                }
            }
            step /= 2;
        }
        print(array);
    }
```

#### 三、交换类排序
##### 1、冒泡排序
冒泡排序通过两两比较，每次将最大或者最小的元素移动到整个序列的一端。
```java
/**
     * 冒泡排序
     * @param array
     */
    public static void bubbleSort(int[] array){
        int temp = 0;
        //每次将最大的放到最后，需要进行length-1次
        for( int i=0; i<array.length-1; i++ ){
            for( int j=1; j<array.length-1-i; j++ ){
                if( array[j]<array[j-1] ){
                    temp = array[j];
                    array[j] = array[j-1];
                    array[j-1] = temp;
                }
            }
        }
        print(array);
    }
```
##### 2、快速排序
快速排序的基本思想是，从序列中任选一个元素，但通常会直接选择序列的第一个元素作为一个标准，所有比该元素值小的元素全部移动到他的左边，比他大的都移动到他的右边。该排序算法是目前为止，内部排序中效率最高的排序算法。
```java
/**
     * 快速排序
     * @param array
     */
    public static void quickSort(int[] array){
        int low = 0;
        int high = array.length-1;
        qSort(array, low, high);
        print(array);
    }

    private static void qSort(int[] array, int low, int high){
        if( low<high ){
            int pos = oneQuickSort(array, low, high);
            qSort(array, low, pos-1);
            qSort(array, pos+1, high);
        }
    }

    private static int oneQuickSort(int[] array, int low, int high){
        int key = array[low];
        while ( low<high ){
            while ( low<high && array[high]>=key ){
                high--;
            }
            array[low] = array[high];
            while ( low<high && array[low]<=key ){
                low++;
            }
            array[high] = array[low];
        }
        array[low] = key;
        return low;
    }
```
#### 四、选择类排序
选择类排序的基本思想是，每一趟会在n个元素中比较n-1次，选择出最大或者最小的一个元素放在整个序列的端点处。
```java
/**
     * 直接选择排序
     * @param array
     */
    public static void selectionSort(int[] array){
        for( int i=0; i<array.length; i++ ){
            int minIdx = i; //记录最小值的位置
            for( int j=i+1; j<array.length; j++ ){
                if( array[j]<array[minIdx] ){
                    minIdx = j;
                }
            }
            if( minIdx!=i ){
                int temp = array[i];
                array[i] = array[minIdx];
                array[minIdx] = temp;
            }
        }
        print(array);
    }
```
#### 五、归并类排序算法
```java
/**
     * 归并排序
     * @param array
     */
    public static void mergeSort(int[] array){
        int len = array.length;
        int[] arrayTemp = new int[len];
        mSort(array, 0, len-1, arrayTemp);
        print(array);
    }

    private static void mSort(int[] array, int low, int high, int[] arrayTemp){
        if( low < high ) {
            int mid = low + (high-low)/2;  //分界
            mSort(array, low, mid, arrayTemp);
            mSort(array, mid+1, high, arrayTemp);
            mergeTwoArray(array, low, mid, high, arrayTemp);
        }
    }

    private static void mergeTwoArray(int[] array, int low, int mid, int high, int[] arrayTemp){
        int i=low, j=mid+1;
        int current = 0;
        while ( i<=mid && j<=high ){
            if( array[i]<array[j] ){
                arrayTemp[current++] = array[i++];
            }else{
                arrayTemp[current++] = array[j++];
            }
        }
        while( i<=mid ){
            arrayTemp[current++] = array[i++];
        }
        while ( j<=high ){
            arrayTemp[current++] = array[j++];
        }
        System.arraycopy(arrayTemp,0,array,low,current);
    }
```
