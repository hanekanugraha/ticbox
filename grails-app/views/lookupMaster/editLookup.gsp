<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="ticbox"/>
    <title>Edit Lookup</title>
</head>

<body>
<div class="row">
    <div class="col-md-12">
        <div class="module">
            <div class="module-header">
                <div class="title">Edit Lookup</div>
            </div>

            <div class="module-content">

                <div style="font-weight: bold; margin-top: 10px;">Edit Lookup</div>

                <g:if test="${flash.message}">
                    <div class="alert alert-success" style="display: block">${flash.message}</div>
                </g:if>

                <g:form name="editLookup" controller="lookupMaster" action="submitLookup" class="form-horizontal" style="margin: 20px 0 0 0;">
                    <input type="hidden" id="lookupCode" value="${lookupMaster.code}"/>

                    <div class="form-group">
                        <label  class="col-sm-2 control-label">Lookup Code</label>
                        <label  class="col-sm-3 control-label">${lookupMaster.code}</label>


                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">Lookup Label</label>
                        <label  class="col-sm-3 control-label">${lookupMaster.label}</label>


                    </div>

                    <div class="row" style="margin-bottom:10px">
                        <div class="col-sm-12">
                            <a id="addValue" href="#add-new-value-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> Add</a>
                            <a id="delValue" href="#delete-value-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> Delete</a>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12">
                        <table id="lookupValueTable" class="table table-bordered table-striped table-hover">
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Lookup Value Code</th>
                                    <th>Lookup Value Description</th>

                                </tr>
                            </thead>
                            <tbody>
                                <g:each  status="i" in="${lookupMaster.values}" var="lookupValue">
                                    <tr name="${i}">
                                        <td><input type="checkbox" name="lookupValueSeq"  value="${i}" /></td>
                                        <td class="mapKey">${lookupValue.key}</td>
                                        <td class="mapValue">${lookupValue.value}</td>
                                    </tr>
                                </g:each>
                            </tbody>
                        </table>
                        </div>
                    </div>



                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-3">
                            <button id="submit" class="btn btn-default btn-green">
                                <span class="glyphicon glyphicon-log-in"></span> Save
                            </button>
                            <button id="cancel" class="btn btn-light-oak btn-md" href="${request.contextPath}/lookupMaster/">Cancel</button>

                        </div>

                    </div>
                </g:form>

            </div>

        </div>
    </div>
</div>

<!-- Add new value modal -->
<div id="add-new-value-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="addNewValueLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="addNewValueLabel" class="modal-title">
                    Add New Value
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
                <g:form name="addNewValueForm"  class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="mapKey" class="col-xs-4 control-label"><g:message code="app.mapkey.label"/></label>
                        <div class="col-xs-8"><g:textField name="mapKey" class="form-control" style="min-width: 70%; width: auto;"/></div>
                    </div>
                    <div class="form-group">
                        <label for="mapValue" class="col-xs-4 control-label"><g:message code="app.mapValue.label"/></label>
                        <div class="col-xs-8"><g:textField name="mapValue" class="form-control" style="min-width: 70%; width: auto;"/></div>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="createNewValue" class="btn btn-green" data-loading-text="Processing..">Add</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
        </div>
    </div>
</div>

<!-- Delete users modal -->
<div id="delete-value-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="deleteValueLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="deleteValueLabel" class="modal-title">
                    Delete Value
                </span>
            </div>
            <div class="modal-body">
                <g:form name="deleteValueForm" role="form">
                    <input type="hidden" id="delValueIds" name="delValueIds" value=""/>
                    <div class="well">
                        <p><b>Are you sure to delete these value?</b></p>
                        There is no rollback for deleted values. Please make sure you know what you are doing.
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="deleteValues" class="btn btn-danger" data-loading-text="Processing..">Delete</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
        </div>
    </div>
</div>



<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">
    $(document).ready(function() {



        $('#submit').click(function() {
            var lookupValues = {};
            jQuery('#lookupValueTable > tbody > tr').each(function(){
                var container = jQuery(this);
                var key=jQuery('.mapKey', container).text();
                var val=jQuery('.mapValue', container).text();
                lookupValues[key]=val;
            });

            jQuery.post('${request.contextPath}/lookupMaster/submitLookup', {lookupValues: JSON.stringify(lookupValues), lookupCode:jQuery('#lookupCode').val()}, function(data){

                if('FAILED' == data){
                    alert('Submission failure');

                }else{
                    alert('Submission success');
                }

            });
        });


        $('#addNewValueForm').validate({
            rules: {
                mapKey: {
                    required: true
                },
                mapValue: {
                    required: true
                }
            }
        });
        $('#createNewValue').click(function() {
            $(this).button('loading');
            var form = $('#addNewValueForm');
            if (form.valid()) {
                var table=$('#lookupValueTable > tbody');
                var lastRow=$('#lookupValueTable > tbody > tr:last');
                if(lastRow.length!=0){
                    var lastSeq=lastRow.attr("name");
                    var cloneRow=lastRow.clone();
                    cloneRow.attr("name",parseInt(lastSeq)+1);
                    cloneRow.empty();

                    var checkbox=cloneRow.append('<td><input type=\"checkbox\" name=\"lookupValueSeq\" /></td>');
                    checkbox.val(parseInt(lastSeq)+1);

                    cloneRow.append('<td class="mapKey">'+$('input[name=mapKey]').val()+'</td>');
                    cloneRow.append('<td class="mapValue">'+$('input[name=mapValue]').val()+'</td>');

                    table.append(cloneRow);
                }
                else{
                    var tr=$('<tr>');
                    var checkbox=tr.append('<td><input type=\"checkbox\" name=\"lookupValueSeq\"/></td>');
                    checkbox.val(parseInt(lastSeq)+1);

                    tr.append('<td class="mapKey">'+$('input[name=mapKey]').val()+'</td>');
                    tr.append('<td class="mapValue">'+$('input[name=mapValue]').val()+'</td>');

                    table.append(tr);
                }
                $(this).button('reset');
                $('#add-new-value-modal').modal('hide');
            } else {
                $(this).button('reset');
            }
        });

        /* Delete values */
        $('#deleteValues').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#deleteValueForm');
            $('input[name=lookupValueSeq]:checked').each(function(id, elmt) {
                $(this).closest('tr').remove();
            });
            $(this).button('reset');
            $('#delete-value-modal').modal('hide');

        });
    });
</script>
</body>
</html>
