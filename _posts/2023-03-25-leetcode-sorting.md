---
layout: post
title: C# Leetcode Sorting
date: 2023-03-25 17:02 +0800
---

## 	No.15 : 3Sum
<p>以範例輸入 nums = [-1,0,1,2,-1,4] 為例 , 先進行排序</p>
<p>得到       nums = [-1,-1,0,1,2,4]  </p>
![Desktop View](/assets/img/2023-03-25-leetcode-sorting/1.png){: width="600" height="500" }
<p>當Arr[iL]+Arr[iR]+Arr[i] == 0 加入到陣列 </p>
<p>此後如果Arr[iL]== Arr[iL+1] 則iL++ (iL指針往右移) </p>
<p>如果Arr[iR]== Arr[iR-1] 則iR— (iR指針往左移 )  </p>

<p>因為以進行過排序 </p>
<p>所以當Arr[iL]+Arr[iR]+Arr[i] < 0  , iL++ (iL指針往右移) </p>
 如果 Arr[iL]+Arr[iR]+Arr[i] > 0  , iR-- (iR指針往左移 
 <script  type='text/javascript' src=''>

    public class Solution {
        public IList<IList<int>> ThreeSum(int[] nums) {
            Array.Sort(nums);
            var temp=  new List<IList<int>>();
            for(int i=0;i<nums.Length-2;i++)
            {
                int iL=i+1;
                int iR=nums.Length-1;
                while(iL<iR)
                {
                    if(nums[i]+nums[iR]+nums[iL]==0)
                    {
                        temp.Add(new List<int>{nums[i],nums[iR],nums[iL]});
                        while(iL<iR && nums[iL]==nums[iL+1])iL++;
                        while(iL<iR && nums[iR]==nums[iR-1])iR--;
                        iL++;
                        iR--;
                    }
                    else if(nums[i]+nums[iR]+nums[iL]<0)iL++;
                    else iR--;
                }
                 while(i<nums.Length-1 && nums[i]==nums[i+1])i++;
            }
            return temp;
        }
    }


## 	No.49 : Group Anagrams


<p>Step1.foreach迴圈,輪詢每個字串 </p>
<p>Step2.使用字元陣列紀錄字串中,每個字元出現的頻率 </p>
![Desktop View](/assets/img/2023-03-25-leetcode-sorting/3.png){: width="600" height="500" }
Step3.建立Dictionary 將字元陣列與字串進行Mapping
 <script  type='text/javascript' src=''>

     public class Solution {
        public IList<IList<string>> GroupAnagrams(string[] strs) {
            var dict =new Dictionary<string,IList<string>>();
            foreach(var item in strs)
            {
                char[] en=new char[26];
                foreach(var it in item)
                {
                    en[it-97]++;
                }
                Console.WriteLine(temp);
                if(dict.ContainsKey(temp)==false)dict.Add(temp,new List<string>{item});
                else dict[temp].Add(item);
            }
            return dict.Values.ToList();
        }
    }


## 	No.56 Merge Intervals
![Desktop View](/assets/img/2023-03-25-leetcode-sorting/2.png){: width="600" height="500" }
<p>題目提供的陣列,可以視為一個括號裡面裝著許多區間</p>
<p>Step1.依據區間的開始與結束,把2維陣列拆解成2個1維陣烈</p>
<p>以intervals = [[1,3],[2,6],[8,10],[15,18]]為例,可以拆成</p>
<p>start= [1,2,8,15]</p>
<p>end = [3,6,10,18]</p>
<p>Step2.使用2個Point,分別為i,j要找start[i]>end[i+1]的項目</p>
<p>i 用在for迴圈輪巡陣列內容</p>
<p>j 用在記錄區最小的起始位置 </p>
![Desktop View](/assets/img/2023-03-25-leetcode-sorting/4.png){: width="200" height="200" }
<script  type='text/javascript' src=''>

     public class Solution {
        public int[][] Merge(int[][] intervals) {
            int[] Start = new int[intervals.Length];
            int[] End = new int[intervals.Length];
            for(int i=0;i<intervals.Length;i++)
            {
                Start[i]=intervals[i][0];
                End[i]=intervals[i][1];
            }
            Array.Sort(Start);
            Array.Sort(End);
            List<int[]> lst=new List<int[]> ();
            for(int i=0,j=0;i<intervals.Length;i++)
            {
                if(i==intervals.Length-1 || Start[i+1]>End[i] )
                {
                    lst.Add(new int[]{Start[j],End[i] });
                    j=i+1;
                }
            }
            return lst.ToArray();
        }
    }
