<!DOCTYPE html>
<html>
	<head>
		<title><g:if env="development">Grails Runtime Exception</g:if><g:else>Ticbox Error Page</g:else></title>
		<meta name="layout" content="ticbox">
		<g:if env="development">
            <link rel="stylesheet" href="${resource(dir: 'css', file: 'errors.css')}" type="text/css">
        </g:if>
	</head>
	<body>
		<g:if env="development">
            <g:if test="${flash.error}">
                <div class="alert alert-danger" style="display: block">${flash.error}</div>
            </g:if>
            <g:if test="${flash.message}">
                <div class="alert alert-success" style="display: block">${flash.message}</div>
            </g:if>
			<g:renderException exception="${exception}" />
		</g:if>
		<g:else>
        %{--<ul class="errors">--}%
        %{--<li>An error has occurred</li>--}%
        %{--</ul>--}%
            <g:if test="${flash.error}">
                <div class="alert alert-danger" style="display: block">${flash.error}</div>
            </g:if>
            <g:if test="${flash.message}">
                <div class="alert alert-success" style="display: block">${flash.message}</div>
            </g:if>
		</g:else>
	</body>
</html>
