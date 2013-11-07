
    <div class="page-header">
        <h4>${pluginName}</h4>
    </div>

    <div id="chart_container">
    </div>


    <script>
        var currentTestId = 0;
        $(document).ready(function() {

        });

        function getTargetPluginDataAndDraw(testId, pluginName, ip) {
            currentTestId = testId;
            $.ajax({
                url: "${req.getContextPath()}/perftest/"+testId+"/plugin/"+pluginName,
                dataType:'json',
                cache: true,
                data: {'monitorIP': ip, 'imgWidth': 700}
            }).done(function(result) {
                if (!targetPluginData[pluginName]) {
                    targetPluginData[pluginName] = {};
                }
                var dataMapOfPlugin = targetPluginData[pluginName];
                dataMapOfPlugin[ip] = result;
                drawPluginChart(result);
            }).fail(function() {
                showErrorMsg("Get monitor data failed!");
            });
        }

        function drawPluginChart(currMonitorData) {
            var headerStr = currMonitorData['header'];
            var headerList = eval(headerStr);
            var $container = $("#chart_container");

            for (var i = 0; i < headerList.length; i++) {
                var currentHead = headerList[i];
                $container.append("<h6>" + currentHead + "</h6><div id='"+ currentHead +"' class='chart'></div>");
                var currentData = currMonitorData[currentHead];
                var dataFormat;
                var currentHeadLow = currentHead.toLowerCase();

                if (currentHeadLow.lastIndexOf("cpu") >= 0) {
                    dataFormat = formatPercentage;
                } else if (currentHeadLow.lastIndexOf("memory") >= 0 || currentHeadLow.lastIndexOf("heap") >= 0) {
                    dataFormat = formatMemoryInByte;
                } else {
                    dataFormat = null;
                }

                drawChart(currentHead, currentData, dataFormat, currMonitorData.interval);
            }
            generateImg(imgBtnLabel, imgTitle);
        }

    </script>