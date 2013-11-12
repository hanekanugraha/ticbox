<%@ page import="org.apache.shiro.SecurityUtils" %>
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title><g:layoutTitle default="TicBOX"/></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
    <link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
    <link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">

    <link rel="stylesheet" href="${resource(dir: 'frameworks/jquery-ui-1.10.2/css/smoothness', file: 'jquery-ui-1.10.2.custom.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'frameworks/bootstrap/css', file: 'bootstrap.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'frameworks/bootstrap/css', file: 'bootstrap-responsive.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'app.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'ticbox.css')}" type="text/css">

    <g:layoutHead/>

</head>
<body>

%{--<div class="container">--}%
<div class="">

    <div class="navbar navbar-inverse navbar-fixed-top">
        <div class="navbar-inner">
            <div class="container-fluid">
                <a class="brand" href="${request.contextPath}/">
                    <img src="${g.resource(dir: 'images/ticbox', file: 'TicBoxLogo.png')}" width="200" height="100">
                </a>
                <div class="nav-collapse collapse">
                    <ul class="nav">
                        <li><g:link>Home</g:link></li>
                        <li><g:link>About us</g:link></li>
                        <li><g:link>How It Works</g:link></li>
                        <li><g:link>Resources</g:link></li>
                        <li><g:link>Pricing</g:link></li>
                        <li><g:link>Blog</g:link></li>
                    </ul>

                    <ul class="login-nav">
                        %{--<li class="help">Help</li>--}%
                        <shiro:notAuthenticated>
                            %{--<li class="sign-up" style="margin-right: 5px;">Sign Up</li>--}%
                            <li class="log-in">
                                <ul class="sign-up-icons">
                                    <li style="background: none; width: auto; margin: 1px 10px 0 0;"><g:link controller="auth" action="login">Register | Login</g:link></li>
                                    <oauth:connect provider="facebook"><li class="fb"></li></oauth:connect>
                                    <oauth:connect provider="twitter"><li class="tw"></li></oauth:connect>
                                    <oauth:connect provider="google"><li class="gg"></li></oauth:connect>
                                </ul>
                            </li>
                        </shiro:notAuthenticated>
                        <shiro:authenticated>
                            <li class="log-in">
                                Hello, ${SecurityUtils.getSubject().getPrincipals().oneByType(String.class)} &nbsp; <g:link controller="auth" action="signOut">Logout</g:link>
                            </li>
                        </shiro:authenticated>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div id="page-outer">
        <div id="main-container" class="wrapper grey">

            %{-- <div class="container shadowed-container"> --}%
            %{--
            <div class="row">
                <div class="span12 header-container shadowed-container" style="position: absolute;">

                    <ul class="login-nav">
                        <li class="help">Help</li>
                        <shiro:notAuthenticated>
                            <li class="sign-up">Sign Up</li>
                            <li class="log-in">
                                <ul class="sign-up-icons">
                                    <li style="background: none; width: auto; margin-right: 10px;"><g:link controller="auth" action="login">Login</g:link></li>
                                    <oauth:connect provider="facebook"><li class="fb"></li></oauth:connect>
                                    <oauth:connect provider="twitter"><li class="tw"></li></oauth:connect>
                                    <oauth:connect provider="google"><li class="gg"></li></oauth:connect>
                                </ul>
                            </li>
                        </shiro:notAuthenticated>
                        <shiro:authenticated>
                            <li class="log-in">
                                Hello, ${SecurityUtils.getSubject().getPrincipals().oneByType(String.class)} &nbsp; <g:link controller="auth" action="signOut">Logout</g:link>
                            </li>
                        </shiro:authenticated>
                    </ul>

                    <a href="${request.contextPath}/"><div class="header-logo pull-left"></div></a>

                    <div class="header-nav navbar pull-right" style="display: table-row">

                        <ul class="nav main-nav">
                            <li><div>Home</div></li>
                            <li class="nav-separator"></li>
                            <li><div>About us</div></li>
                            <li class="nav-separator"></li>
                            <li><div>How It Works</div></li>
                            <li class="nav-separator"></li>
                            <li><div>Resources</div></li>
                            <li class="nav-separator"></li>
                            <li><div>Pricing</div></li>
                            <li class="nav-separator"></li>
                            <li><div>Blog</div></li>
                        </ul>

                    </div>

                </div>
            </div>
            --}%

            %{--<div class="row">
                <div class="span12 body-container">--}%
            <div id="main" style="margin: 0; padding: 0; position: relative; float: left;">
                <div class="">
                    <script type="text/javascript" src="${resource(dir: 'frameworks/jquery-ui-1.10.2/js', file: 'jquery-1.9.1.js')}"></script>
                    <script type="text/javascript" src="${resource(dir: 'frameworks/jquery-ui-1.10.2/js', file: 'jquery-ui-1.10.2.custom.js')}"></script>
                    <script type="text/javascript" src="${resource(dir: 'frameworks/bootstrap/js', file: 'bootstrap.js')}"></script>

                    <g:if test="${flash.error}">
                        <div class="alert alert-error" style="display: block">${flash.error}</div>
                    </g:if>
                    <g:if test="${flash.message}">
                        <div class="alert alert-success" style="display: block">${flash.message}</div>
                    </g:if>

                    <g:layoutBody/>

                </div>

                <div style="margin: 15px auto;">
                    <div class="row">

                        <div class="span2 bottom-nav" style="width: 120px; padding-left: 30px;">
                            <ul style="margin: 0">
                                <li><strong>Company</strong></li>
                                <li>Our Story</li>
                                <li>Our Team</li>
                                <li>Press</li>
                            </ul>
                        </div>

                        <div class="span2 bottom-nav" style="width: 120px;">
                            <ul style="margin: 0">
                                <li><strong>Tools</strong></li>
                                <li>Survey Express</li>
                                <li>Survey Mobile</li>
                                <li>Survey Tracker</li>
                            </ul>
                        </div>

                        <div class="span2 bottom-nav" style="width: 120px;">
                            <ul style="margin: 0">
                                <li><strong>Support</strong></li>
                                <li>Contact Us</li>
                                <li>FAQ</li>
                            </ul>
                        </div>

                        <div class="span6" style="float: right; margin-right: 49px; width: 475px;">
                            <div class="security-logo pull-right"></div>
                        </div>

                    </div>
                    <div class="row">
                        <div class="page-footer">
                            <ul>
                                <li>Term Of Use</li>
                                <li>|</li>
                                <li>Privacy Policy</li>
                                <li>|</li>
                                <li>Anti Spam Policy</li>
                                <li>|</li>
                                <li>Security Statement</li>
                                <li>|</li>
                                <li>Survey Opt-Out</li>
                            </ul>
                        </div>
                    </div>
                </div>

            </div>
            %{-- </div> --}%
        </div>
    </div>



</div>

<script type="text/javascript">

    jQuery(function(){

        jQuery('.link').click(function(){
            var href = jQuery(this).attr('href');
            if(href){
                window.location.href = href;
            }
        });

        jQuery('.datePicker').datepicker({
            showAnim : 'slideDown',
            dateFormat : '<g:message code="app.date.format.js" default="dd/mm/yy"/>',
            changeMonth: true,
            changeYear: true,
            yearRange: 'c-60:c+10'
        });

    });

</script>


</body>
</html>
