---
layout: post
title: C# Refactoring Reference
date: 2022-11-13 23:18 +0800
---

# 前言

# 開始
## Step1.
避免Method的參數為Method的用法  
`Method` : [BreakIntoSentences](#breaklonglines)、[Cleanup](#cleanup)、[Breakintosentences](#breakintosentences)    
`Interface` : [ITextProcessor](#itextprocessor)  
`Class`  : [LinesTrimmer](#linestrimmer)  
![Desktop View](/assets/img/2022-11-13-c-sharp-refactoring-reference/1.png){: width="600" height="500" }  
## Step2.
將回傳連續String的Method，拆解成物件，且物件繼承相同的Interface  
`Interface` : [ITextProcessor](#itextprocessor)  
`Class`  : [SentencesBreaker](#sentencesbreaker)、[LinesBreaker](#linesbreaker)、[LinesTrimmer](#linestrimmer)  
<br/>
![Desktop View](/assets/img/2022-11-13-c-sharp-refactoring-reference/2.png){: width="600" height="500" }  
## Step3-方法1.
建立新的Interface 「ITextProcessor」來處理這些「繼承相同的Interface」的Class  
`Interface` : [ITextProcessor](#itextprocessor)    
`Class`  : [Pipeline](#pipeline)  
![Desktop View](/assets/img/2022-11-13-c-sharp-refactoring-reference/3-1.png){: width="600" height="500" }  
## Step3-方法2.
同上  
![Desktop View](/assets/img/2022-11-13-c-sharp-refactoring-reference/3-2.png){: width="600" height="500" }  
## Step3-方法3.
建立靜態Method來處理這些「繼承相同的Interface」的Class  
`Interface` : [ITextProcessor](#itextprocessor)  
`Class`  : [Pipeline](#)、[LinesTrimmer](#linestrimmer)  
![Desktop View](/assets/img/2022-11-13-c-sharp-refactoring-reference/3-3.png){: width="600" height="500" }  
## Step4.
參數個別存在時"沒有意義"，所以將其重構為Class  
`Class`  : [TimedText](#timedtext)    
![Desktop View](/assets/img/2022-11-13-c-sharp-refactoring-reference/4.png){: width="600" height="500" }  
## 總覽  
![Desktop View](/assets/img/2022-11-13-c-sharp-refactoring-reference/5.png){: width="600" height="500" }  
# 參考Source-Code

## BreakLongLines
[To Step1](#step1)
<script  type='text/javascript' src=''>

    private static IEnumerable<string> BreakLongLines(
        IEnumerable<string> text, int maxLineCharacters, int minBrokenLength)
    {
        string remaining = string.Empty;
        yield return remaining;
    }


## BreakIntoSentences
[To Step1](#step1)

範例  
<script  type='text/javascript' src=''>

    private static IEnumerable<string> BreakIntoSentences(IEnumerable<string> text)
    {
        string remaining = string.Empty;
        yield return remaining;
    }


## Cleanup
[To Step1](#step1)

範例  
<script  type='text/javascript' src=''>

    private static IEnumerable<string> Cleanup(string[] text)
    {
        string remaining = string.Empty;
        yield return remaining;
    }



## ITextProcessor
[To Step1](#step1)
[To Step2](#step2)
[To Step3](#step3)

範例  
<script  type='text/javascript' src=''>

    internal interface ITextProcessor
    {
        IEnumerable<string> Execute(IEnumerable<string> text);
    }





## SentencesBreaker
[To Step2](#step2)

範例  
<script  type='text/javascript' src=''>

    internal interface ITextProcessor
    {
        IEnumerable<string> Execute(IEnumerable<string> text);
    }
    class SentencesBreaker : ITextProcessor
    {
        public IEnumerable<string> Execute(IEnumerable<string> text)
        {
            string remaining = string.Empty;
            yield return remaining;
        }

        private IEnumerable<string> BreakSentences(string text)
        {
            string remaining = text.Trim();
            yield return remaining;
        }
    }




## LinesBreaker
[To Step2](#step2)

範例  
<script  type='text/javascript' src=''>

    internal interface ITextProcessor
    {
        IEnumerable<string> Execute(IEnumerable<string> text);
    }
    class LinesBreaker : ITextProcessor
    {
        private int MaxLineLength { get; }
        private int MinLengthToBreakInto { get; }

        public LinesBreaker(int maxLineLength, int minLengthToBreakInto)
        {
            this.MaxLineLength = maxLineLength;
            this.MinLengthToBreakInto = minLengthToBreakInto;
        }
        public IEnumerable<string> Execute(IEnumerable<string> text) 
        {
            string remaining = text.Trim();
            yield return remaining;
        }

        public IEnumerable<string> BreakLongLine(string line)
        {
            string remaining = line.Trim();
            yield return remaining;
        }

    }




## LinesTrimmer
[To Step1](#step1)
[To Step2](#step2)
[To Step3](#step3-方法3)

範例  
<script  type='text/javascript' src=''>

    class LinesTrimmer : ITextProcessor
    {
        public IEnumerable<string> Execute(IEnumerable<string> text)  
        {
            string remaining = text.Trim();
            yield return remaining;
        }

    }




## Pipeline
[To Step1](#step3-方法1)
[To Step3](#step3-方法3)
範例  
<script  type='text/javascript' src=''>

    internal interface ITextProcessor
    {
        IEnumerable<string> Execute(IEnumerable<string> text);
    }
    class Pipeline : ITextProcessor
    {
        private IEnumerable<ITextProcessor> Processors { get; }

        public Pipeline(IEnumerable<ITextProcessor> processors)
        {
            this.Processors = processors.ToList();
        }

        public Pipeline(params ITextProcessor[] processors)
            : this((IEnumerable<ITextProcessor>) processors)
        {
        }

        public IEnumerable<string> Execute(IEnumerable<string> text) =>
            this.Processors.Aggregate(text, (current, processor) => processor.Execute(current));
    }




## TimedText
[To Step4](#step4)
 
範例  
<script  type='text/javascript' src=''>

    class TimedText
    {
        public IEnumerable<string> Content { get; }
        public TimeSpan Duration { get; }

        public TimedText(IEnumerable<string> content, TimeSpan duration)
        {
            this.Content = content;
            this.Duration = duration;
        }

        public TimedText Apply(ITextProcessor processor) =>
            new TimedText(processor.Execute(this.Content), this.Duration);
    }




