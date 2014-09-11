<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="ticbox"/>
    <title>Edit Parameter</title>
</head>

<body>
<div class="row">
    <div class="col-md-12">
        <div class="module">
            <div class="module-header">
                <div class="title">Edit Parameter</div>
            </div>

            <div class="module-content">

                <div style="font-weight: bold; margin-top: 10px;">Edit Parameter</div>

                <g:if test="${flash.message}">
                    <div class="alert alert-success" style="display: block">${flash.message}</div>
                </g:if>

                <g:form name="editParameter" controller="parameter" action="submitParameter" class="form-horizontal" style="margin: 20px 0 0 0;">
                    <input type="hidden" name="parameterCode" value="${parameter.code}"/>

                    <div class="form-group">
                        <label  class="col-sm-2 control-label">Parameter Code</label>
                        <label  class="col-sm-3 control-label">${parameter.code}</label>


                    </div>

                    <div class="form-group">
                        <label for="parameterValue" class="col-sm-2 control-label">Parameter Value</label>
                        <div class="col-sm-3">
                            <input type="text" class="form-control" name="parameterValue" id="parameterValue" value="${parameter.value}" placeholder="Parameter Value"/>
                        </div>


                    </div>



                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-3">
                            <button id="submit" class="btn btn-default btn-green">
                                <span class="glyphicon glyphicon-log-in"></span> Edit
                            </button>

                        </div>

                    </div>
                </g:form>

            </div>

        </div>
    </div>
</div>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">
    $(document).ready(function() {

        $('input[name="parameterValue"]').focus();

        $('#submit').click(function() {
            $('#submitParameter').submit();
        });


        $('#editParameter').validate({
            rules: {
                parameterValue: {
                    required: true

                }
            }
        });
    });
</script>
</body>
</html>
