---
title: 剑指offer-正则表达式匹配
date: 2019-07-09 11:08:42
tags:
- 剑指offer
- 正则表达式

categories:
- 剑指offer
---

### 题目描述
请实现一个函数用来匹配包括`'.'`和 `'*'` 的正则表达式。模式中的字符`'.'`表示任意一个字符，而  `'*'` 表示它前面的字符可以出现任意次（包含0次）。 在本题中，匹配是指字符串的所有字符匹配整个模式。例如，字符串`"aaa"`与模式`"a.a"`和`"ab*ac*a"`匹配，但是与`"aa.a"`和`"ab*a"`均不匹配。

<!-- more -->

### 题解

---

markdown里面的 \* 需要转义，一个个转实在有点麻烦，还是把文字放在代码块里好了。

```scheme
我们可以把问题转换为当前字符的下一个字符是否为 * 来处理，那么就归纳为以下几种情况：

1. 如果字符串当前位置的下一个字符不是*，那么：
	# 字符串与模式的当前位置字符匹配：字符串和模式的索引均向后移一位，继续匹配之后的；
	# 字符串与模式的当前位置字符不匹配：返回false。
    
2. 如果字符串当前位置下一个字符是*，那么：
	# 如果当前位置字符不匹配：模式索引后移2位，字符串不变，相当于 x* 这两个字符被忽略掉，
						因为 * 可以匹配0次；
	# 如果当前位置字符匹配，有三种方式继续匹配，采取递归来一一试探：
		## 模式索引后移2位，字符串不变，相当于 x* 这两个字符被忽略掉；
			这里解释下为什么这么做。
			举个栗子，"bbbba"和".*a"，如果到了第4个b的时候没有把".*"给跳过去，那么
             ".*"还会继续匹配下个字符a，那么模式中的a就得不到匹配，返回false。实际上
             如果".*"匹配了4个b，然后再匹配最后那个a，是true的；
		## 字符串索引后移1位，模式不变，即使用当前字符继续匹配字符串，因为 * 可以匹配多次；
		## 字符串索引后移1位，模式后移2位，即 x* 只匹配1次。
```

**代码如下：**

```java
public class Solution {
    
    public boolean match(char[] str, char[] pattern)
    {
        if( str==null || pattern==null ) return false;
        return matchSub(str, 0, pattern, 0);
    }
    
    public boolean matchSub(char[] str, int strIdx, char[] p, int pIdx){
        //如果匹配完成，返回true
        if( strIdx==str.length && pIdx==p.length ) return true;
        //如果pattern先到最后，返回false，这样的话匹配是必定失败的
        if( strIdx != str.length && pIdx==p.length ) return false;
        
        //第二个是*
        if( pIdx+1 < p.length && p[pIdx+1]=='*' ){
            //字符串没到尾，且当前位置匹配，三种情况
            if( strIdx!=str.length && str[strIdx]==p[pIdx] || strIdx != str.length && p[pIdx]=='.' ){
                return matchSub(str, strIdx, p, pIdx+2) || matchSub(str, strIdx+1, p, pIdx)
                    || matchSub(str, strIdx+1, p, pIdx+2);
                
            }else {
                //字符串到尾，或者当前位置不匹配，都把模式向后移动2位，因为*是可以匹配0次的
                return matchSub(str, strIdx, p, pIdx+2);
            }
        }

        //第二个不是*，且当前位置匹配
        if( strIdx != str.length && (str[strIdx] == p[pIdx] || p[pIdx]=='.') ){
            return matchSub(str, strIdx+1, p, pIdx+1);
        }
        return false;
    }
}
```