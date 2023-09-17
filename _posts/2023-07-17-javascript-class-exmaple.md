---
layout: post
title: JavaScript Class Exmaple
date: 2023-07-17 23:02 +0800
---
# JavaScript 靜態工廠
<p>附圖為C#與JavaScript使用Class的等效語法</p>
![Desktop View](/assets/img/2023-07-17-javascript-class-exmaple/1.png){: width="600" height="500" }
範例
<script  type='text/javascript' src=''>

    class RequestDemo {
        constructor(TableName, ActionName) {
            this.tableName = TableName;
            this.ActionName = ActionName;
        }
        static Creat(TableName, ActionName) {
            return new RequestDemo(TableName, ActionName);
        }
        Run() {
            console.log(this.tableName, this.ActionName);
        }
    }


# JavaScript 驗證與提示分離簡易架構

範例
<script  type='text/javascript' src=''>

      class RequireSave {
          constructor() { }
          /**建立輸入驗證 */
          static Creat()
          {
              return new RequireSave();
          }
          static Test() {
              const temp = RequireSave.Creat().Valid();
              if (temp['IsSuccess'] === false) alert(temp['Describe']);
          }
          /**一口氣驗證所有必填項目,是否都有填寫 */
          Valid() {
              let IsSuccess = true;
              let Describe = '';
              let Methods = [];
              Methods.push(this.MyDomItem);

              for (const method of Methods) {
                  const result = method();
                  if (result.IsSuccess === false) {
                      IsSuccess = false;
                      Describe += `${result.Describe} \n`;
                  }
              }
              return { 'IsSuccess': IsSuccess, 'Describe': Describe }
          }
          /*Vaild DOM ITEM*/
          MyDomItem() {
              let jqr = { 'IsSuccess': true, 'Describe': '' };
              const temp = $('#MyDomItem').val()
              if (temp === '') {
                  jqr = { 'IsSuccess': false, 'Describe': '警告' };
              }
              return jqr;
          }
      }


# JavaScript MVVM簡易寫法

以下是簡單的MVVM示範
情境是3種ComboBox變更時,5個label會有不同對應的變化
<script  type='text/javascript' src=''>

    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MVVM Example with Different ComboBox Behaviors</title>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <h1>Multiple ComboBoxes with Different Behaviors</h1>
        <select id="countrySelector">
            <option value="USA">USA</option>
            <option value="Canada">Canada</option>
            <option value="UK">UK</option>
            <option value="Australia">Australia</option>
        </select>
        <select id="colorSelector">
            <option value="Red">Red</option>
            <option value="Blue">Blue</option>
            <option value="Green">Green</option>
        </select>
        <select id="fruitSelector">
            <option value="Apple">Apple</option>
            <option value="Banana">Banana</option>
            <option value="Orange">Orange</option>
        </select>

        <div class="info">
            <h2>Information</h2>
            <p><strong>Name:</strong> <span id="infoName"></span></p>
            <p><strong>Category:</strong> <span id="infoCategory"></span></p>
            <p><strong>Description:</strong> <span id="infoDescription"></span></p>
            <p><strong>Price:</strong> <span id="infoPrice"></span></p>
            <p><strong>Availability:</strong> <span id="infoAvailability"></span></p>
        </div>

        <script>
            // Model
            class InfoModel {
                constructor() {
                    this.data = {
                        countries: {
                            USA: { Name: "United States", Category: "Country", Description: "A country in North America", Price: "N/A", Availability: "Yes" },
                            Canada: { Name: "Canada", Category: "Country", Description: "A country in North America", Price: "N/A", Availability: "Yes" },
                            UK: { Name: "United Kingdom", Category: "Country", Description: "A country in Europe", Price: "N/A", Availability: "Yes" },
                            Australia: { Name: "Australia", Category: "Country", Description: "A country in Oceania", Price: "N/A", Availability: "Yes" }
                        },
                        colors: {
                            Red: { Name: "Red", Category: "Color", Description: "A color associated with passion", Price: "$5", Availability: "In stock" },
                            Blue: { Name: "Blue", Category: "Color", Description: "A color associated with tranquility", Price: "$6", Availability: "In stock" },
                            Green: { Name: "Green", Category: "Color", Description: "A color associated with nature", Price: "$4", Availability: "In stock" }
                        },
                        fruits: {
                            Apple: { Name: "Apple", Category: "Fruit", Description: "A fruit that keeps the doctor away", Price: "$2", Availability: "In stock" },
                            Banana: { Name: "Banana", Category: "Fruit", Description: "A curved yellow fruit", Price: "$1", Availability: "In stock" },
                            Orange: { Name: "Orange", Category: "Fruit", Description: "A citrus fruit full of vitamin C", Price: "$3", Availability: "In stock" }
                        }
                    };
                }

                getInfo(category, name) {
                    return this.data[category][name];
                }
            }

            // ViewModel
            class InfoViewModel {
                constructor(model) {
                    this.model = model;
                    this.$countrySelector = $('#countrySelector');
                    this.$colorSelector = $('#colorSelector');
                    this.$fruitSelector = $('#fruitSelector');
                    this.$infoName = $('#infoName');
                    this.$infoCategory = $('#infoCategory');
                    this.$infoDescription = $('#infoDescription');
                    this.$infoPrice = $('#infoPrice');
                    this.$infoAvailability = $('#infoAvailability');

                    this.$countrySelector.change(() => this.updateCountryInfo());
                    this.$colorSelector.change(() => this.updateColorInfo());
                    this.$fruitSelector.change(() => this.updateFruitInfo());
                }

                updateCountryInfo() {
                    const selectedName = this.$countrySelector.val();
                    const info = this.model.getInfo('countries', selectedName);
                    this.updateInfoElements(info);
                }

                updateColorInfo() {
                    const selectedName = this.$colorSelector.val();
                    const info = this.model.getInfo('colors', selectedName);
                    this.updateInfoElements(info);
                }

                updateFruitInfo() {
                    const selectedName = this.$fruitSelector.val();
                    const info = this.model.getInfo('fruits', selectedName);
                    this.updateFruitInfoElements(info);
                }

                updateInfoElements(info) {
                    this.$infoName.text(info.Name);
                    this.$infoCategory.text(info.Category);
                    this.$infoDescription.text(info.Description);
                    this.$infoPrice.text(info.Price);
                    this.$infoAvailability.text(info.Availability);
                }

                updateFruitInfoElements(info) {
                    this.$infoName.text(info.Name);
                    this.$infoCategory.text(info.Category);
                    this.$infoDescription.text(info.Description);
                    this.$infoPrice.text("Price not applicable for fruits");
                    this.$infoAvailability.text(info.Availability);
                }
            }

            // Initialization
            const model = new InfoModel();
            const viewModel = new InfoViewModel(model);
        </script>
    </body>
    </html>
