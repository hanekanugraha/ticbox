<%--
  Created by IntelliJ IDEA.
  User: geuispuspita
  Date: 1/6/14
  Time: 4:23 PM
--%>

                <footer>
                    %{--<div class="row bottom-nav">--}%
                        %{--<div class="col-md-2">--}%
                            %{--<ul>--}%
                                %{--<li><strong>Company</strong></li>--}%
                                %{--<li>Our Story</li>--}%
                                %{--<li>Our Team</li>--}%
                                %{--<li>Press</li>--}%
                            %{--</ul>--}%
                        %{--</div>--}%
                        %{--<div class="col-md-2">--}%
                            %{--<ul>--}%
                                %{--<li><strong>Tools</strong></li>--}%
                                %{--<li>Survey Express</li>--}%
                                %{--<li>Survey Mobile</li>--}%
                                %{--<li>Survey Tracker</li>--}%
                            %{--</ul>--}%
                        %{--</div>--}%
                        %{--<div class="col-md-2">--}%
                            %{--<ul>--}%
                                %{--<li><strong>Support</strong></li>--}%
                                %{--<li>Contact Us</li>--}%
                                %{--<li>FAQ</li>--}%
                            %{--</ul>--}%
                        %{--</div>--}%

                        %{--<div class="col-md-6" id="security-logo">--}%
                            %{--<ul>--}%
                                %{--<li>--}%
                                    %{--<img src="${request.contextPath}/images/ticbox/SecurityLogoForMockUp.jpg" class="img-responsive">--}%
                                %{--</li>--}%
                            %{--</ul>--}%
                        %{--</div>--}%
                    %{--</div>--}%

                    <div class="row policies-nav">
                        <div class="col-md-12">
                            <ul class="hr-list text-center">
                                <li>
                                    <a href="${request.contextPath}/policies/termsOfUse"><g:message code="app.termsofuse.label"/></a>
                                </li>
                                <li>
                                    <a href="${request.contextPath}/policies/surveyContent"><g:message code="app.surveycontentpolicy.label"/></a>
                                </li>
                                <li>
                                    <a href="${request.contextPath}/policies/surveyTermsOfService"><g:message code="app.surveytermsofservice.label"/></a>
                                </li>
                                <li>
                                    <a href="${request.contextPath}/policies/privacy"><g:message code="app.privacypolicy.label"/></a>
                                </li>
                                <li class="hr-list-end">
                                    <a href="${request.contextPath}/policies/antiSpam"><g:message code="app.antispampolicy.label"/></a>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="bottom-nav">
                        <div id="widget">
                            <span>Copyright </span>
                            <span class="glyphicon glyphicon-copyright-mark"></span>
                            <span> 2014 Ticbox. All Rights Reserved. &nbsp;</span>
                            <span>
                                <a href="https://twitter.com/ticboxSurvey" class="twitter-follow-button" data-show-count="false" data-dnt="true">Follow @ticboxSurvey</a>
                            </span>
                            <script>
                                !function(d,s,id){
                                    var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
                                    if(!d.getElementById(id)){
                                            js=d.createElement(s);
                                            js.id=id;js.src=p+'://platform.twitter.com/widgets.js';
                                            fjs.parentNode.insertBefore(js,fjs);
                                    }
                                }(document, 'script', 'twitter-wjs');
                            </script>
                        </div>
                    </div>

                    %{--<div class="row copyright-nav">--}%
                        %{--<div class="col-md-12" style="margin-top: 5px">--}%
                            %{--<ul class="text-center">--}%
                                %{--<li>Copyright <span class="glyphicon glyphicon-copyright-mark"></span> 2014 Ticbox. All Rights Reserved.</li>--}%
                            %{--</ul>--}%
                        %{--</div>--}%
                    %{--</div>--}%
                </footer>

