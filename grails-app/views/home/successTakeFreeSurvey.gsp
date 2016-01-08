<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="ticbox"/>
    <title><g:message code="app.thankyoupage.title"/> </title>
</head>

<body>
<div class="row">
    <div class="col-md-12">
        <div class="module">
            <div class="module-header">
                <div class="title"><g:message code="app.thankyoupage.label"/></div>
            </div>

            <div class="module-content">

                <div style="font-weight: bold; margin-top: 10px;"><g:message code="app.thankyoupage.content"/></div>

                <g:if test="${flash.message}">
                    <div class="alert alert-success" style="display: block">${flash.message}</div>
                </g:if>



            </div>


        </div>
    </div>
</div>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>

</body>
</html>
