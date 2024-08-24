---
layout: post
title: c-sharp-WPF的Binding與Modal與Xaml研究
date: 2024-08-25 00:21 +0800
---
## 前言
<p>這邊紀錄我在維護ASP.NET Core時在Razor中常碰到的語法使用方式 (可能有些不局限於ASP.NET Core)</p>


<H1>Modal 綁定UI 簡單寫法</H1>

## Step1.建立Modal並繼承 INotifyPropertyChanged
然後實作OnPropertyChanged
要注意屬性資料的寫法 一定要像範例中那樣
```
 public class BaseInfo : INotifyPropertyChanged
 {
     public event PropertyChangedEventHandler PropertyChanged;
     protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
     {
         PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
     }
     private string _CodeName;

     public string CodeName
     {
         get => _CodeName;
         set
         {
             if (_CodeName != value)
             {
                 _CodeName = value;
                 OnPropertyChanged(nameof(CodeName));
             }
         }
     }
 }
```    
## Step2.Xaml設定資料綁定
a.設定綁定Modal

在 xmlns:local底下 加入Modal的namespace
```
xmlns:modal="clr-namespace:test.Domain.Model
```
以及設定namespace底下的Class
```
    <Window.DataContext>
        <modal:BaseInfo />
    </Window.DataContext>
```

b.綁定Property
以textBox為例 Biding大概這樣寫
```
   <TextBox Text="{Binding CodeName, Mode=TwoWay}"/>
```



## Step3.透過讀取綁定的Modal資料來撰寫商業邏輯的方式
a.建立RelayCommand並繼承 ICommand
```
public class RelayCommand : ICommand
{
    private readonly Action<object> _execute;
    private readonly Func<object, bool> _canExecute;

    public RelayCommand(Action<object> execute, Func<object, bool> canExecute = null)
    {
        _execute = execute;
        _canExecute = canExecute;
    }

    public bool CanExecute(object parameter)
    {
        return _canExecute == null || _canExecute(parameter);
    }

    public void Execute(object parameter)
    {
        _execute(parameter);
    }

    public event EventHandler CanExecuteChanged
    {
        add { CommandManager.RequerySuggested += value; }
        remove { CommandManager.RequerySuggested -= value; }
    }
}
```

b.方才的Modal物件要擁有 ICommand的屬性資料
```
 public class BaseInfo : INotifyPropertyChanged
 {
     public ICommand SubmitCommand { get; }
     public BaseInfo()
     {
         // 初始化命令并绑定业务逻辑
         SubmitCommand = new RelayCommand(ExecuteSubmit, CanExecuteSubmit);
     }
     public event PropertyChangedEventHandler PropertyChanged;
     protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
     {
         PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
     }
     private string _CodeName;

     public string CodeName
     {
         get => _CodeName;
         set
         {
             if (_CodeName != value)
             {
                 _CodeName = value;
                 OnPropertyChanged(nameof(CodeName));
             }
         }
     }
     
      private void ExecuteSubmit(object parameter)
     {
         // 这里是按钮点击后执行的业务逻辑
         MessageBox.Show($"You entered: ");
     }

     private bool CanExecuteSubmit(object parameter)
     {
         // 可以在这里添加按钮是否可用的逻辑，比如判断 Text 是否为空
         return true;
     }
 }
```


c.xaml設定ICommand的Binding

```
 <Button x:Name="btn_SHOW_JSON" Command="{Binding SubmitCommand}"/>
```
d.補充說明 SubmitCommand 傳入參數的方式
可以使用CommandParameter
```
<Button Content="Submit" 
        Command="{Binding SubmitCommand}" 
        CommandParameter="Hello, World!" />
```
上述為輸入參數為"Hello, World!"
下面為讀取參數"Hello, World!"的方式

```
private void ExecuteSubmit(object parameter)
{
    string message = parameter as string;
    MessageBox.Show(message); // This will show "Hello, World!"
}
```

也可以傳遞Xaml物件
```
<TextBox Name="InputTextBox" Width="200" Margin="10"/>
<Button Content="Submit" 
        Command="{Binding SubmitCommand}" 
        CommandParameter="{Binding Text, ElementName=InputTextBox}" />
```

## Step4.控制按鈕狀態
寫一個Class 去繼承IValueConverter
```
 public class BoolToVisibilityConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            bool isVisible = (bool)value;
            return isVisible ? Visibility.Visible : Visibility.Collapsed;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
```
xaml的部分會像這樣
```
    <Window.Resources>
        <!-- Register the converter -->
        <local:BoolToVisibilityConverter x:Key="BoolToVisibilityConverter"/>
    </Window.Resources>


  <TextBlock Text="This is visible or hidden"
                   Visibility="{Binding IsTextVisible, Converter={StaticResource BoolToVisibilityConverter}}"
                   VerticalAlignment="Center"
                   HorizontalAlignment="Center"/>
```


## Step5.單純寫text驗證的方式

範例xaml
```
<Grid>
    <StackPanel>
        <TextBox Text="{Binding FirstName, UpdateSourceTrigger=PropertyChanged, ValidatesOnDataErrors=True, NotifyOnValidationError=True}" 
                 Margin="10"/>
        <TextBlock Foreground="Red" Text="{Binding (Validation.Errors)[0].ErrorContent}"   Margin="10"/>

        <TextBox Text="{Binding LastName, UpdateSourceTrigger=PropertyChanged, ValidatesOnDataErrors=True, NotifyOnValidationError=True}" 
                 Margin="10"/>
        <TextBlock Foreground="Red" Text="{Binding (Validation.Errors)[1].ErrorContent}"  Margin="10"/>

        <TextBox Text="{Binding Age, UpdateSourceTrigger=PropertyChanged, ValidatesOnDataErrors=True, NotifyOnValidationError=True}" 
                 Margin="10"/>
        <TextBlock Foreground="Red" Text="{Binding (Validation.Errors)[2].ErrorContent}"  Margin="10"/>
    </StackPanel>
</Grid>
```

範例C#
```
    public partial class MainWindow : Window
    {
        public Person Person { get; set; }
        public MainWindow()
        {
            InitializeComponent();

            // Initialize the Person object and set DataContext
            Person = new Person();
            DataContext = Person;
        }
    }
    public class Person : IDataErrorInfo
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int Age { get; set; }

        // IDataErrorInfo Implementation
        public string this[string columnName]
        {
            get
            {
                switch (columnName)
                {
                    case nameof(FirstName):
                        if (string.IsNullOrWhiteSpace(FirstName))
                            return "First name is required.";
                        break;

                    case nameof(LastName):
                        if (string.IsNullOrWhiteSpace(LastName))
                            return "Last name is required.";
                        break;

                    case nameof(Age):
                        if (Age < 0 || Age > 120)
                            return "Age must be between 0 and 120.";
                        break;
                }
                return null;
            }
        }

        public string Error => null; // No global error
    }
```




