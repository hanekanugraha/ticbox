<html>
    <head>
        <meta name="layout" content="ticbox">
        <title><g:message code="app.welcome.message"/></title>

    </head>
    <body>

        <div class="jumbotron" style="padding: 15px 20px 28px 28px; margin-bottom: 20px;">
            <h1 style="color:#525252; font-size: 46px"><g:message code="homepage.title1.label"/></h1>
            <p style="font-size: 14px">
                <g:message code="homepage.content1.label"/>
            </p>
            <p>
                %{--<button class="btn btn-green btn-lg"><g:message code="label.button.watch.video"/></button>--}%
            </p>
        </div>

        <div class="clearfix home-content module features" style="padding-bottom: 40px">
            <div style="padding-left: 12px">
                <g:message code="homepage.title2.label"/>
                %{--<h3>A <span class="marroon">Solution</span> For You.</h3>--}%
                <p class="nowrap" style="font-size: 14px; padding-bottom: 10px">
                    <g:message code="homepage.content2.label"/>
                </p>

                <h3><g:message code="homepage.title3.label"/></h3>
                <h4>
                    <g:message code="homepage.content3.label"/>
                </h4>
            </div>
            <div style="font-size: 14px; text-align: center;">
                <div class="col-sm-2">
                    <span class="glyphicon glyphicon glyphicon-list-alt features-icon"></span>
                    <g:message code="homepage.easysurvey.label"/>
                </div>
                <div class="col-sm-2">
                    <span class="glyphicon glyphicon-bullhorn features-icon"></span>
                    <g:message code="homepage.publish.label"/>
                </div>
                <div class="col-sm-2">
                    <span class="glyphicon glyphicon-phone features-icon"></span>
                    <g:message code="homepage.mobile.label"/>
                </div>
                <div class="col-sm-2">
                    <span class="glyphicon glyphicon-flash features-icon"></span>
                    <g:message code="homepage.responses.label"/>
                </div>
                <div class="col-sm-2">
                    <span class="glyphicon glyphicon-stats features-icon"></span>
                    <g:message code="homepage.analyze.label"/>
                </div>
                <div class="col-sm-2">
                    <span class="glyphicon glyphicon-file features-icon"></span>
                    <g:message code="homepage.download.label"/>
                </div>
            </div>
        </div>


    <div class="clearfix home-content " style="padding: 24px;margin-bottom: 50px; text-align: center;">
        <img src="images/ticbox/collaterals/work-in-progress2.jpg" class="img-responsive img-thumbnail" style="margin: auto" width="100%" height="auto" alt="Solution For You"/>
        %{--<div style="width: 100%; height: 300px; background-image: url(images/ticbox/collaterals/work-in-progress.jpg); background-repeat: no-repeat; background-position: 0 -200px; margin: auto; background-size: 80% auto; background-position: center"></div>--}%
        <h3><g:message code="homepage.ourpeople.label"/></h3>
        <p class="nowrap" style="font-size: 14px">
            <g:message code="homepage.content4.label"/>
        </p>
        <br>
        <button class="btn btn-blue-trust btn-lg center"><g:message code="label.button.learncommunities"/> </button>
    </div>

                <script type="text/javascript">
                    $('#aboutUs').tooltip({'placement': 'right','content':'html'});
                </script>
    </body>
</html>
