<%--
  Created by IntelliJ IDEA.
  User: arnold
  Date: 4/13/13
  Time: 9:56 PM
--%>

<%@ page import="ticbox.Survey" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="surveyor"/>
    <title></title>

    <style type="text/css">
        .qq-upload-button {
            margin: auto;
        }

        .qq-upload-button, .qq-upload-button input[type="file"] {
            opacity: 0;
        }

        img.upload-pic {
            width: auto;
            max-height: 150px;
        }
    </style>

    <script type="text/javascript">

        var ttlQuestions = 0;
        var answerId=0;

        jQuery(function() {
            console.log('~ BEGIN jQuery function');
            jQuery('#surveyorProfileContent').addClass('out');
            <!-- jQuery('#surveyInfoAccordion').show(); -->
            jQuery('#surveyInfoAccordion').hide();
            jQuery('#surveyInfoContainer').addClass('out');

            jQuery('#uploadLogoBtn').click(function(){
                jQuery('#au-imageUploader .qq-upload-button > input')
                        .attr('accept', 'image/*')
                        .trigger('click');
            });

            jQuery('#finalizeSurveyBtn').click(function(){
                var questionItems = buildQuestionItemsMap();
                if(validateQuestionItems(questionItems)=='success') {
                    jQuery('#submit-confirmation-modal').modal('show');
                } else if(validateQuestionItems(questionItems)=='singleChoiceNotValid') {
                    jQuery('#validate-choice-question-items-modal').modal('show');
                } else if(validateQuestionItems(questionItems)=='multipleChoiceNotValid') {
                    jQuery('#validate-choice-question-items-modal').modal('show');
                } else if(validateQuestionItems(questionItems)=='scaleRatingNotValid') {
                    jQuery('#validate-matrix-question-items-modal').modal('show');
                } else {
                    jQuery('#validate-question-items-modal').modal('show');
                }
            });

            jQuery('#pickLogoBtn').click(function(){
                logoId = jQuery('input.logoResourceId:checked').val();

                if (logoId) {
                    jQuery('#surveyLogo > img').attr('src', '${request.contextPath}/survey/viewResources?resType=LOGO&resourceId='+logoId).attr('data-image-id', logoId);
                    jQuery('#chooseLogoModal').modal('hide');
                }
            });

            jQuery('#nextButton').click(function(){
                jQuery('#singleQuestionNextModal').modal('hide');
            });

            jQuery('.surveyItemTypeAdd').click(function(){
                var validate=false;
                var addItemComponent=jQuery(this);

                    var questions =0;
                    jQuery('.surveyItemsContainer > .surveyItemContainer').each(function(idx){
                        questions++;
                    });

                        console.log('~ surveyItemTypeAdd.clicked');
                        var type = addItemComponent.attr('type');
                        var subtype = addItemComponent.attr('subtype');
                        %{--if("${survey.type}"=="${Survey.SURVEY_TYPE.FREE}"&&type=="SCALE_RATING") {--}% // demo testing
                            %{--alert('Free Survey not support scale');--}%
                        %{--}--}%
                        %{--else--}%
                        constructQuestionItem(type, subtype); // This is called


            });

            jQuery('#saveSurveyBtn').click(function(){

                var questionItems = buildQuestionItemsMap();

                submitSurvey(questionItems);

            });

            jQuery('#surveyTitle').val('${survey.title}');

            jQuery.getJSON('${request.contextPath}/survey/getQuestionItems', {}, function(questionItems){

                loadSurvey(questionItems);

            });

//            jQuery('#surveyPreviewModal').on('shown', function(){
            jQuery('#surveyPreviewModal').on('shown.bs.modal', function(){
                console.log('~ BEGIN #surveyPreviewModal.onShown');
                var questionItems = buildQuestionItemsMap();
                constructPreview(questionItems);

//            }).on('hidden', function(){
            }).on('hidden.bs.modal', function(){
                jQuery('#surveyPreviewModal .modal-body').empty();
            })/*.css({
                'width': function () {
                    return ($(document).width() * .8) + 'px';
                },
                'margin-left': function () {
                    return -($(this).width() / 2);
                }
            })*/;

//            jQuery('#chooseLogoModal').on('show', function(){
            jQuery('#chooseLogoModal').on('show.bs.modal', function(){

                if(jQuery('#chooseLogoModal .modal-body').html().trim() == ''){ //TODO .is(:empty) doesn't work -___-'
                    jQuery.getJSON('${request.contextPath}/survey/getLogoIds', {}, function(data){

                        jQuery('#chooseLogoModal .modal-body').empty();
                        jQuery.each(data, function(idx, id){
                            populateLogoImageResources(id);
                        });

                    });
                }

                if (logoId) {
                    jQuery('input.logoResourceId[value="'+ logoId +'"]', jQuery('#chooseLogoModal')).next('a').trigger('click'); //TODO to accommodate prettyCheckable
                }

//            }).on('hide', function(){
            }).on('hide.bs.modal', function(){

                        //TODO

            });

            jQuery('#singleQuestionNextModal .nextButton').click(function(){
                nextQuestionId = jQuery('input.nextQuestionId:checked').val();
                jQuery('.item-seq[answerid='+jQuery('#singleQuestionNextModal .modal-body').attr('answerid')+']').val(nextQuestionId);
                jQuery('#singleQuestionNextModal').modal('hide');
            });

        });

        var logoId = null;

        function populateLogoImageResources(id){
            var modal = jQuery('#chooseLogoModal');
            var logoWrapper = jQuery('.templates .logoWrapper').clone().appendTo(jQuery('.modal-body', modal));

            jQuery('input.logoResourceId', logoWrapper).val(id).prettyCheckable();

            jQuery('.logoImg', logoWrapper).attr('src', "${request.contextPath}/survey/viewResources?resType=LOGO&resourceId="+id).click(function(){
                //jQuery('input[name="logoResourceId"]', logoWrapper).prop('checked', true);
                jQuery('a', logoWrapper).trigger('click'); //TODO to accommodate prettyCheckable
            });
        }

        function populateImageResources(id){
            var modal = jQuery('#chooseImageModal');
            var logoWrapper = jQuery('.templates .logoWrapper').clone().appendTo(jQuery('.modal-body', modal));

            jQuery('input.logoResourceId', logoWrapper).val(id).prettyCheckable();

            jQuery('.logoImg', logoWrapper).attr('src', "${request.contextPath}/survey/viewResources?resType=IMAGE&resourceId="+id).click(function(){
                jQuery('a', logoWrapper).trigger('click'); //TODO to accommodate prettyCheckable
            });
        }

        var pureQuestionTemplate = null;
        function constructQuestionItem(type, subtype){
            var answerComp = null;

            var changeTypeIconClass = '';

            switch(type){

                case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :

                    answerComp = jQuery('#answerTemplate-choice-single').clone().removeAttr('id');

                    jQuery('.choice-type', answerComp).val('single');

                    changeTypeIconClass = 'single-choice-icon';

                    jQuery('.question-action-btn.upload-pic-icon', answerComp).click(function(){
                        openImageUploader(jQuery(this));
                    });

                    jQuery('.question-next',answerComp).attr('answerid',answerId);
                    jQuery('.item-seq',answerComp).attr('answerid',answerId);
                    answerId++;

                    jQuery('.question-next',answerComp).click(function(){
                        jQuery('#singleQuestionNextModal .modal-body').empty();

                        jQuery('.surveyItemsContainer > .surveyItemContainer').each(function(idx){
                            var seq=jQuery(jQuery(this)).attr('seq');
                            var nextQuestionWrapper = jQuery('.templates .nextQuestionWrapper').clone().appendTo(jQuery('#singleQuestionNextModal .modal-body'));
                            jQuery('.questionNumber', nextQuestionWrapper).html(seq);
                            jQuery('.nextQuestionId', nextQuestionWrapper).val(seq);
                            jQuery('#singleQuestionNextModal .modal-body').attr('answerid',jQuery('.item-seq',answerComp).attr('answerid'));

                        });

                        jQuery('#singleQuestionNextModal').modal('show');

                    });

                    jQuery('.add-item', answerComp).click(function(){
                        var newItem = jQuery('.choice-item:first', '#answerTemplate-choice-single').clone().removeAttr('id');

                        jQuery('.item-label', newItem).val('');

                        newItem.appendTo(jQuery('.choice-items', answerComp));

                        jQuery('input.item-check', newItem).click(function(){
                            newItem.remove();
                        });

                        jQuery('.question-next',newItem).attr('answerid',answerId);
                        jQuery('.item-seq',newItem).attr('answerid',answerId);
                        answerId++;

                        jQuery('.question-next',newItem).click(function(){
                            jQuery('#singleQuestionNextModal .modal-body').empty();

                            jQuery('.surveyItemsContainer > .surveyItemContainer').each(function(idx){
                                var seq=jQuery(jQuery(this)).attr('seq');
                                var nextQuestionWrapper = jQuery('.templates .nextQuestionWrapper').clone().appendTo(jQuery('#singleQuestionNextModal .modal-body'));
                                jQuery('.questionNumber', nextQuestionWrapper).html(seq);
                                jQuery('.nextQuestionId', nextQuestionWrapper).val(seq);
                                jQuery('#singleQuestionNextModal .modal-body').attr('answerid',jQuery('.item-seq',newItem).attr('answerid'));

                            });

                            jQuery('#singleQuestionNextModal').modal('show');

                        });

                        jQuery('.question-action-btn.upload-pic-icon', newItem).click(function(){
                            openImageUploader(jQuery(this));
                        });

                    });


                    break;

                case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :

                    answerComp = jQuery('#answerTemplate-choice-multiple').clone().removeAttr('id');

                    jQuery('.choice-type', answerComp).val('multiple');

                    changeTypeIconClass = 'multiple-choice-icon';

                    jQuery('.question-action-btn.upload-pic-icon', answerComp).click(function(){
                        openImageUploader(jQuery(this));
                    });

                    jQuery('.add-item', answerComp).click(function(){
                        var newItem = jQuery('.choice-item:first', '#answerTemplate-choice-multiple').clone().removeAttr('id');
                        jQuery('.item-label', newItem).val('');

                        newItem.appendTo(jQuery('.choice-items', answerComp));

                        jQuery('input.item-check', newItem).click(function(){
                            newItem.remove();
                        });

                        jQuery('.question-action-btn.upload-pic-icon', newItem).click(function(){
                            openImageUploader(jQuery(this));
                        });
                    });

                    break;

                case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                    answerComp = jQuery('#answerTemplate-singleText').clone().removeAttr('id');
                    changeTypeIconClass = 'free-text-icon';

                    break;

                case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                    answerComp = jQuery('#answerTemplate-scale').clone().removeAttr('id');

                    jQuery('.remove-row', answerComp).click(function() {
                        var totalRow = jQuery('.scale-row', answerComp).length;

                        if(totalRow > 1)
                            jQuery('.scale-row:last', answerComp).remove();
                    });

                    jQuery('.add-row', answerComp).click(function(){
                        var row = jQuery('.scale-row:first', answerComp).clone();
                        jQuery('.row-label', row).val('');
                        jQuery('table', answerComp).append(row);
                        jQuery('.rating-weight > input', row).attr('name', 'rd-'+jQuery('.scale-row',answerComp).size());
                    });

                    jQuery('.remove-rating', answerComp).click(function() {
                        var totalRating = jQuery('.rating-label', answerComp).length;

                        if(totalRating > 1) {
                            jQuery('.rating-label:last', answerComp).remove();

                            jQuery('.scale-row', answerComp).each(function(idx){
                                jQuery('.rating-weight:last', jQuery(this)).remove();

                            });
                        }
                    });

                    jQuery('.add-rating', answerComp).click(function(){
                        var ratingLabel = jQuery('.rating-label', '#answerTemplate-scale').clone();
                        jQuery(this).parent().before(ratingLabel);

                        jQuery('.scale-row', answerComp).each(function(idx){
                            var ratingWeight = jQuery('.rating-weight', '#answerTemplate-scale').clone();
                            jQuery('.rating-weight:last', jQuery(this)).after(ratingWeight);
                            jQuery('input', ratingWeight).attr('name', jQuery('.rating-weight > input:first',ratingWeight.parent()).attr('name'));
                        });
                    });

                    changeTypeIconClass = 'scale-rating-icon';

                    break;

                case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                    answerComp = jQuery('#answerTemplate-starRating').clone().removeAttr('id');
                    changeTypeIconClass = 'star-rating-icon';

                    jQuery('.add-star', answerComp).click(function(){
                        if (jQuery('.stars .star', answerComp).length < 10) {
                            jQuery('.stars', answerComp).append(jQuery('<div class="col star"></div>'));
                        }
                    });

                    jQuery('.remove-star', answerComp).click(function(){
                        if (jQuery('.stars .star', answerComp).length > 3) {
                            jQuery('.stars .star:first', answerComp).remove();
                        }
                    });


                    break;

            }

            if (pureQuestionTemplate == null) {
              pureQuestionTemplate = jQuery('#questionTemplate').clone();
            }
            var questionComp = pureQuestionTemplate.clone().removeAttr('id').append(answerComp).appendTo('.surveyItemsContainer');

            jQuery('.question-action-btn.upload-pic-icon', questionComp).click(function(){
                openImageUploader(jQuery(this));
            });

            // Sanchez
            // An uploader for this button
            /*new qq.FileUploader({
                element: jQuery('.question-level-upload .image-uploader', questionComp)[0],
                action: '/ticbox/survey/uploadImageToString',
                onComplete: function(id, fileName, responseJSON) {
                    jQuery('.question-level-upload img.pic', questionComp).attr('src', 'data:image;base64,' + responseJSON.img);
                    jQuery('.question-level-upload input[type="hidden"]', questionComp).val(responseJSON.fid);
                    jQuery('.qq-upload-list', questionComp).empty()

                    var curWidth = parseInt(jQuery('.questionTextContainer', questionComp).css('width'));
                    jQuery('.questionTextContainer').css('width', (curWidth - 150) + 'px');
                }
            });*/

            jQuery('.change-question-type-btn', questionComp).addClass(changeTypeIconClass);

            jQuery('.surveyItemsContainer > .surveyItemContainer').each(function(idx){
                jQuery('.questionNumber', jQuery(this)).html(idx + 1 + '.');
                jQuery(this).attr('seq',idx+1);
            });

            jQuery('.surveyItemActions .remove', questionComp).click(function(){
                var ok = confirm ('<g:message code="survey.deletequestion.label"/>');
                if (ok == true) {
                    jQuery(this).parents('.surveyItemContainer').remove();
                    jQuery('.surveyItemsContainer > .surveyItemContainer').each(function (idx) {
                        jQuery('.questionNumber', jQuery(this)).html(idx + 1 + '.');
                        jQuery(this).attr('seq', idx + 1);
                    });
                }
            });

            jQuery('.surveyItemActions .up', questionComp).click(function(){
                jQuery(this).parents('.surveyItemContainer').insertBefore(jQuery(this).parents('.surveyItemContainer').prev());
                jQuery('.surveyItemsContainer > .surveyItemContainer').each(function (idx) {
                    jQuery('.questionNumber', jQuery(this)).html(idx + 1 + '.');
                    jQuery(this).attr('seq', idx + 1);
                });
            });

            jQuery('.surveyItemActions .down', questionComp).click(function(){
                jQuery(this).parents('.surveyItemContainer').insertAfter(jQuery(this).parents('.surveyItemContainer').next());
                jQuery('.surveyItemsContainer > .surveyItemContainer').each(function (idx) {
                    jQuery('.questionNumber', jQuery(this)).html(idx + 1 + '.');
                    jQuery(this).attr('seq', idx + 1);
                });
            });

            return questionComp;
        }

        function buildQuestionItemsMap(){
            console.log('~ BEGIN buildQuestionItemsMap');
            var questionItems = [];
            var seq = 0;

            jQuery('.surveyItemsContainer > .surveyItemContainer').each(function(){
                console.log('~ BEGIN .surveyItemsContainer > .surveyItemContainer each');

                var container = jQuery(this);
                var type = jQuery('.answerTemplate', container).attr('type');

                var questionStr = jQuery('.questionTextContainer > textarea', container).val();
                var questionImg = jQuery('.question-row input.image-id', container).val();

                var answerDetails = {};
                answerDetails['type'] = type;

                switch(type){
                    case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :
                        console.log('~ type is multi choice');

                        answerDetails['choiceItems'] = [];
                        jQuery('.choice-items > .choice-item', container).each(function(){

                            var item = jQuery(this);
                            var choiceItem = {};
                            choiceItem['label'] = jQuery('input.item-label', item).val();
                            choiceItem['image'] = jQuery('input.image-id', item).val();
                            answerDetails['choiceItems'].push(choiceItem);
                        });

                        answerDetails['choiceType'] = jQuery('select.choice-type', container).val();

                        console.log('@buildQuestionItemsMap: CHOICE_MULTIPLE = ' + JSON.stringify(answerDetails, null, "    "));

                        break;

                    case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :
                        console.log('~ type is single choice');

                        answerDetails['choiceItems'] = [];
                        jQuery('.choice-items > .choice-item', container).each(function(){

                            var item = jQuery(this);
                            var choiceItem = {};
                            choiceItem['label'] = jQuery('input.item-label', item).val();
                            choiceItem['rule'] = 'selected';
                            choiceItem['nextQuestion'] = jQuery('input.item-seq', item).val();
                            choiceItem['label'] = jQuery('input.item-label', item).val();
                            choiceItem['image'] = jQuery('input.image-id', item).val();

                            answerDetails['choiceItems'].push(choiceItem);
                        });

                        answerDetails['choiceType'] = jQuery('select.choice-type', container).val();

                        break;

                    case '${Survey.QUESTION_TYPE.FREE_TEXT}' :
                        answerDetails['questionPlaceholder'] = jQuery('textarea.place-holder-text', container).val();
                        console.log('~ type is free text, answerDetails: ' + answerDetails['questionPlaceholder']);
                        break;

                    case '${Survey.QUESTION_TYPE.SCALE_RATING}' :
                        console.log('~ type is scale rating');

                        answerDetails['ratingLabels'] = [];
                        jQuery('table.scale-table > thead .rating-label input', container).each(function(){

                            answerDetails['ratingLabels'].push(jQuery(this).val());

                        });

                        answerDetails['rowLabels'] = [];
                        jQuery('table.scale-table > tbody input.row-label', container).each(function(){

                            answerDetails['rowLabels'].push(jQuery(this).val());

                        });

                        break;

                    case '${Survey.QUESTION_TYPE.STAR_RATING}' :
                        answerDetails['nofStars'] = jQuery('.stars .star', container).length;
                        console.log('~ type is star rating, answerDetails: ' + answerDetails['nofStars']);
                        break;

                }

                var questionItem = {
                   seq : ++seq,
                   questionStr : questionStr,
                   image : questionImg,
                   answerDetails : answerDetails
                };

console.log('@buildQuestionItemsMap: questionItem = ' + JSON.stringify(questionItem, null, "    "));

                questionItems.push(questionItem);

            });

            return questionItems
        }

        function deleteQuestion(){
            jQuery(this).parents('.surveyItemContainer').remove();
            jQuery('.surveyItemsContainer > .surveyItemContainer').each(function(idx){
                jQuery('.questionNumber', jQuery(this)).html(idx + 1 + '.');
                jQuery(this).attr('seq',idx+1);
            });
        }

        function submitSurvey(questionItems){
            show_loader();

            jQuery.post('${request.contextPath}/survey/submitSurvey', {questionItems: JSON.stringify(questionItems), surveyTitle: jQuery('#surveyTitle').val(), logoResourceId:jQuery('#surveyLogo > img').attr('data-image-id')}, function(data){

                if('SUCCESS' == data){
                    flashMessage('<g:message code="message.survey.survey-generator.saved"/>', true);
                }else if('LIMIT' == data){
                    flashMessage('Max Free Survey more than limit..', false);
                }else{
                    flashMessage('Submission failure', false);
                }

                hide_loader();

            });
        }

        function validateQuestionItems(questionItems) {
//            var isValid = true
            var isValid = 'success'
            if(questionItems) {
                jQuery.each(questionItems, function(idx, item) {
                    var answerDetails = item.answerDetails;

                    // kucingkurus
                    if(item.questionStr.length>0) {

                        switch (answerDetails.type) {

                            case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :
                                var singleChoiceItems = answerDetails.choiceItems;
                                if (singleChoiceItems.length <= 1) {
                                    isValid = 'singleChoiceNotValid'
                                    return isValid
                                }
                                jQuery.each(singleChoiceItems, function(idx, singleChoiceItem){
                                    if(singleChoiceItem.label == ' ' || singleChoiceItem.label.length <=0) {
                                        isValid = 'singleChoiceNotValid'
                                        return isValid
                                    }
                                });
                                break;

                            case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :
                                var multipleChoiceItems = answerDetails.choiceItems;
                                if (multipleChoiceItems.length <= 1) {
                                    isValid = 'multipleChoiceNotValid'
                                    return isValid
                                }

//                                jQuery.each(multipleChoiceItems, function(idx, multipleChoiceItem) {
//                                    alert('hula = ' + multipleChoiceItem.label + ' jumlah str = ' + multipleChoiceItem.label.length)
//                                    if(multipleChoiceItem.label == ' ' || multipleChoiceItem.label.length <=0) {
//                                        isValid = 'multipleChoiceNotValid'
//                                        return isValid
//                                    }
//                                });
                                break;

                            case '${Survey.QUESTION_TYPE.FREE_TEXT}' :
                                break;

                            case '${Survey.QUESTION_TYPE.SCALE_RATING}' :
                                var ratingLabels = answerDetails.ratingLabels;
                                var rowLabels = answerDetails.rowLabels;


                                // check total ratings
                                if(ratingLabels.length <=1) {
                                    isValid = 'scaleRatingNotValid'
                                    break;
                                } else if(ratingLabels.length > 1) {
                                    // check empty label
                                    for (var i = 0; i < ratingLabels.length; i++) {

                                        if (ratingLabels[i].length <= 0 || ratingLabels[i] == ' ') {
                                            isValid = 'scaleRatingNotValid'
                                        }

                                    }

                                    for (var j = 0; j < rowLabels.length; j++) {
                                        if (rowLabels[j].length <= 0 || rowLabels[j] == ' ') {
                                            isValid = 'scaleRatingNotValid'
                                        }
                                    }
                                }



                                break;

                            case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                                break;
                        }
                    } else {
                        isValid = 'failed'
                    }

                })
            }

            return isValid;
        }

        function saveAndSubmitSurvey() {
            jQuery('#validate-choice-question-items-modal').modal('hide');
            show_loader();

            var questionItems = buildQuestionItemsMap();

                jQuery.post('${request.contextPath}/survey/submitAndFinalizeSurvey', {questionItems: JSON.stringify(questionItems), surveyTitle: jQuery('#surveyTitle').val(), logoResourceId:jQuery('#surveyLogo > img').attr('data-image-id')}, function(data){


                    if('SUCCESS' == data){
                    	jQuery('#submit-confirmation-modal').modal('hide');
	                    flashMessage('<g:message code="message.survey.survey-generator.submitted"/>', true);
                   		window.location = "${request.contextPath}/survey/index";
                    }else if('LIMIT' == data){
                        flashMessage('Max Free Survey more than limit..', false);
                    }else{
                        flashMessage('Submission failure', false);
//                        window.location = data;
                    }

                    hide_loader();
                });

        }

        function loadSurvey(questionItems){

            console.log('@buildQuestionItemsMap: questionItems = ' + JSON.stringify(questionItems, null, "    "));

            if (questionItems) {

                jQuery.each(questionItems, function(idx, item){

                    var answerDetails = item.answerDetails;
                    var container = null;

                    switch(answerDetails.type) {

                        case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :

                            var choiceItems = answerDetails.choiceItems;
                            var choiceType = answerDetails.choiceType;

                            container = constructQuestionItem(answerDetails.type, choiceType);

                            jQuery.each(choiceItems, function(idx, choiceItem){
                                var choiceItemCont = jQuery('.choice-items > .choice-item:first', container).clone();
                                jQuery('.choice-items', container).append(choiceItemCont);

                                jQuery('.item-label', choiceItemCont).val(choiceItem.label);
                                jQuery('.item-seq', choiceItemCont).val(choiceItem.nextQuestion);

                                jQuery('input.image-id', choiceItemCont).val(choiceItem.image);
                                jQuery('img.upload-pic', choiceItemCont).attr('src', '${request.contextPath}/survey/viewResources?resType=IMAGE&resourceId=' + choiceItem.image);

                                jQuery('.question-next',choiceItemCont).attr('answerid',answerId);
                                jQuery('.item-seq',choiceItemCont).attr('answerid',answerId);
                                answerId++;

                                jQuery('input.item-check', choiceItemCont).click(function(){
                                    choiceItemCont.remove();
                                });

                                jQuery('.question-next',choiceItemCont).click(function(){

                                    jQuery('#singleQuestionNextModal .modal-body').empty();

                                    jQuery('.surveyItemsContainer > .surveyItemContainer').each(function(idx){
                                        var seq=jQuery(jQuery(this)).attr('seq');
                                        var nextQuestionWrapper = jQuery('.templates .nextQuestionWrapper').clone().appendTo(jQuery('#singleQuestionNextModal .modal-body'));
                                        jQuery('.questionNumber', nextQuestionWrapper).html(seq);
                                        jQuery('.nextQuestionId', nextQuestionWrapper).val(seq);
                                        jQuery('#singleQuestionNextModal .modal-body').attr('answerid',jQuery('.item-seq',choiceItemCont).attr('answerid'));

                                    });


                                    jQuery('#singleQuestionNextModal').modal('show');
                                });

                                jQuery('.question-action-btn.upload-pic-icon', choiceItemCont).click(function(){
                                    openImageUploader(jQuery(this));
                                });

                            });
                            jQuery('.choice-items > .choice-item:first', container).remove();

                            jQuery('select.choice-type', container).val(choiceType);

                            break;

                        case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :

                            var choiceItems = answerDetails.choiceItems;
                            var choiceType = answerDetails.choiceType;

                            container = constructQuestionItem(answerDetails.type, choiceType);

                            jQuery.each(choiceItems, function(idx, choiceItem){
                                var choiceItemCont = jQuery('.choice-items > .choice-item:first', container).clone();
                                jQuery('.choice-items', container).append(choiceItemCont);

                                jQuery('.item-label', choiceItemCont).val(choiceItem.label);
                                jQuery('input.image-id', choiceItemCont).val(choiceItem.image);
                                jQuery('img.upload-pic', choiceItemCont).attr('src', '${request.contextPath}/survey/viewResources?resType=IMAGE&resourceId=' + choiceItem.image);

                                jQuery('input.item-check', choiceItemCont).click(function(){
                                    choiceItemCont.remove();
                                });

                                jQuery('.question-action-btn.upload-pic-icon', choiceItemCont).click(function(){
                                    openImageUploader(jQuery(this));
                                });
                            });
                            jQuery('.choice-items > .choice-item:first', container).remove();

                            jQuery('select.choice-type', container).val(choiceType);

                            break;

                        case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                            var questionPlaceHolder = answerDetails.questionPlaceholder;

                            container = constructQuestionItem(answerDetails.type);

                            jQuery('textarea.place-holder-text', container).val(questionPlaceHolder);

                            break;

                        case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                            var ratingLabels = answerDetails.ratingLabels;
                            var rowLabels = answerDetails.rowLabels;

                            container = constructQuestionItem(answerDetails.type);

                            jQuery.each(ratingLabels, function(idx, ratingLabel){
                                var ratingLabelCont = jQuery('table.scale-table > thead th.rating-label:first', container).clone();
                                jQuery('table.scale-table > thead > tr.scale-head > th.rating-label:last', container).after(ratingLabelCont);
                                jQuery('input', ratingLabelCont).val(ratingLabel);
                            });
                            jQuery('table.scale-table > thead th.rating-label:first', container).remove();

                            jQuery.each(rowLabels, function(idx, rowLabel){
                                var rowLabelCont = jQuery('table.scale-table > tbody > tr.scale-row:first', container).clone();
                                jQuery('table.scale-table > tbody', container).append(rowLabelCont);
                                jQuery('input.row-label', rowLabelCont).val(rowLabel);
                                for(var i = 1; i < ratingLabels.length; i++){
                                    jQuery('td.rating-weight:first', rowLabelCont).after(jQuery('td.rating-weight:first', rowLabelCont).clone());
                                }
                            });
                            jQuery('table.scale-table > tbody > tr.scale-row:first', container).remove();

                            break;

                        case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                            container = constructQuestionItem(answerDetails.type);

                            var stars = jQuery('.stars', container).empty();
                            for(var i = 0; i < parseInt(answerDetails.nofStars); i++){
                                stars.append(jQuery('<div class="col star clickable" seq="'+i+'"></div>'));
                            }

                            break;

                    }

                    jQuery('.questionTextContainer textarea', container).val(item.questionStr);
                    jQuery('.question-row input.image-id', container).val(item.image);
                    jQuery('.question-row img.upload-pic', container).attr('src', '${request.contextPath}/survey/viewResources?resType=IMAGE&resourceId=' + item.image);

                });

            }

        }

        function constructPreview(questionItems){
            console.log('~ BEGIN constructPreview');
            jQuery.each(questionItems, function(idx, item){

                var questionStr = item.questionStr;
                var answerDetails = item.answerDetails;

                var questionTemplate = jQuery('#questionPreviewTemplate').clone().removeAttr('id');

                jQuery('.seqNumberContainer', questionTemplate).html(idx+1+'.');
                // Sanchez
                console.log("class of img = " + jQuery('img', questionTemplate).attr('class'));
                if (item.img != null) {
                  jQuery('img', questionTemplate).attr('src', item.img);
                  jQuery('img', questionTemplate).show(0);
                } else {
                  jQuery('img', questionTemplate).hide(0);
                }

                jQuery('.question-text', questionTemplate).html("<span style='font-size:24px;color:grey;'>"+questionStr.charAt(0)+"</span>" + questionStr.substring(1));

                var answerTemplate = null;

                switch(answerDetails.type){

                    case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :

                        var choiceItems = answerDetails.choiceItems;
                        var choiceType = answerDetails.choiceType;


                        answerTemplate = jQuery('#answerPreviewTemplate-singleChoice').clone().removeAttr('id');

//                                jQuery.each(choiceItems, function(idx, choiceItem){
                        jQuery.each(choiceItems, function(j, choiceItem){
//                                    jQuery('.item-select', answerTemplate).append(jQuery('<option></option>').append(choiceItem).val(choiceItem));
                            var choiceItemContainer = jQuery('.choice-item:first', answerTemplate).clone();
                            jQuery('input.item-check', choiceItemContainer).attr('name', idx);
                            jQuery('input.item-check', choiceItemContainer).val(choiceItem);

                            jQuery('.item-label', choiceItemContainer).html(choiceItem.label);
//                                    answerTemplate.append(choiceItemContainer);
                            // Sanchez
                            if (choiceItem.img != null) {
                              jQuery('img', choiceItemContainer).attr('src', choiceItem.img);
                              jQuery('img', choiceItemContainer).show(0);
                            } else {
                              jQuery('img', choiceItemContainer).hide(0);
                            }

                            jQuery('.choice-items', answerTemplate).append(choiceItemContainer);  //<-- geuis edit
                        });
                        jQuery('.choice-item:first', answerTemplate).remove();


                        break;

                    case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :

                        var choiceItems = answerDetails.choiceItems;
                        var choiceType = answerDetails.choiceType;

                        answerTemplate = jQuery('#answerPreviewTemplate-multipleChoice').clone().removeAttr('id');

//                                jQuery.each(choiceItems, function(idx, choiceItem){
                        jQuery.each(choiceItems, function(j, choiceItem){
                            var choiceItemContainer = jQuery('.choice-item:first', answerTemplate).clone();
                            jQuery('input.item-check', choiceItemContainer).val(choiceItem.label);
                            jQuery('.item-label', choiceItemContainer).html(choiceItem.label);
//                                    answerTemplate.append(choiceItemContainer);
                            // Sanchez
                            if (item.img != null) {
                              jQuery('img', choiceItemContainer).attr('src', choiceItem.img);
                              jQuery('img', choiceItemContainer).show(0);
                            } else {
                              jQuery('img', choiceItemContainer).hide(0);
                            }
                            jQuery('.choice-items', answerTemplate).append(choiceItemContainer);  //<-- geuis edit
                        });
                        jQuery('.choice-item:first', answerTemplate).remove();

                        break;

                    case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                        answerTemplate = jQuery('#answerPreviewTemplate-singleText').clone().removeAttr('id');
                        jQuery('textarea', answerTemplate).attr('placeholder', answerDetails.questionPlaceholder);

                        break;

                    case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                        answerTemplate = jQuery('#answerPreviewTemplate-scale').clone().removeAttr('id');

                        var ratingLabels = answerDetails.ratingLabels;
                        var rowLabels = answerDetails.rowLabels;

                        jQuery.each(ratingLabels, function(idx, ratingLabel){
                            jQuery('.scale-head', answerTemplate).append(jQuery('<th class="rating-label" style="text-align: center"></th>').html(ratingLabel));
                        });

                        jQuery.each(rowLabels, function(idx, rowLabel){
                            var scaleRow = jQuery('table.scale-table > tbody > tr.scale-row:first', answerTemplate).clone();
                            jQuery('.row-label', scaleRow).html(rowLabel);

                            jQuery.each(ratingLabels, function(idx, ratingLabel){
                                var ratingWeightCont = jQuery('td.rating-weight:first', scaleRow).clone();
                                jQuery('input', ratingWeightCont).attr('name', rowLabel);
                                scaleRow.append(ratingWeightCont);
                            });
                            jQuery('td.rating-weight:first', scaleRow).remove();

                            jQuery('table.scale-table > tbody', answerTemplate).append(scaleRow);
                        });
                        jQuery('table.scale-table > tbody > tr.scale-row:first', answerTemplate).remove();

                        break;

                    case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                        answerTemplate = jQuery('#answerPreviewTemplate-starRating').clone().removeAttr('id');
                        var stars = jQuery('.stars', answerTemplate).empty();
                        for(var i = 0; i < parseInt(answerDetails.nofStars); i++){
                            jQuery('.stars', answerTemplate).append(jQuery('<div class="col star clickable" seq="'+i+'"></div>').click(function(){
                                var seq = parseInt(jQuery(this).attr('seq'));
                                jQuery('.star', stars).each(function(idx){
                                    if(idx <= seq){
                                        jQuery(this).removeClass('basic');
                                        jQuery(this).addClass('active');
                                    }else{
                                        jQuery(this).removeClass('active');
                                        jQuery(this).addClass('basic');
                                    }
                                });

                            }));
                        }

                        break;

                }

                if (answerTemplate) {
                    questionTemplate.append(answerTemplate);
                }

                jQuery('#surveyPreviewModal').find('.modal-body').append(questionTemplate);

            });
        }

        function openImageUploader(item) {

            //galleryImageUploader(item);
            //or
            tempContImageUploader(item);
        }

        function tempContImageUploader(item) {
            jQuery('#au-surveyItemImageUploader .qq-upload-button > input').trigger('click').change(function(){show_loader();});

            jQuery('#confirmImageBtn').unbind('click').click(function(){
                var modal = jQuery('#previewImageModal');
                var img = jQuery('img.upload-pic', item);
                var imageId = jQuery('.image-id', item);

                logoId = jQuery('#uploadedImageResId').val();

                if (logoId) {
                    img.attr('src', '${request.contextPath}/survey/viewResources?resType=IMAGE&resourceId=' + logoId);
                    imageId.val(logoId);
                    modal.modal('hide');
                    hide_loader();
                }
            });
        }

        function galleryImageUploader(item) {

            var modal = jQuery('#chooseImageModal');
            var img = jQuery('img.upload-pic', item);
            var imageId = jQuery('.image-id', item);

            jQuery('#uploadImageBtn', modal).unbind('click').click(function(){
                jQuery('#au-surveyItemImageUploader .qq-upload-button > input').trigger('click');
            });

            jQuery('#pickImageBtn', modal).unbind('click').click(function(){
                logoId = jQuery('input.logoResourceId:checked', modal).val();

                if (logoId) {
                    img.attr('src', '${request.contextPath}/survey/viewResources?resType=IMAGE&resourceId=' + logoId);
                    imageId.val(logoId);
                    modal.modal('hide');
                }

            });

            if(jQuery('.modal-body', modal).html().trim() == ''){
                jQuery.getJSON('${request.contextPath}/survey/getResourceIds?resType=IMAGE', {}, function(data){

                    jQuery('.modal-body', modal).empty();
                    jQuery.each(data, function(idx, id){
                        populateImageResources(id);
                    });

                    if(imageId.val()){
                        jQuery("input.logoResourceId[value='"+ imageId.val() +"']", modal).next('a').trigger('click');
                    }

                    modal.modal('show');

                });
            } else {
                if(imageId.val()){
                    jQuery("input.logoResourceId[value='"+ imageId.val() +"']", modal).next('a').trigger('click');
                }

                modal.modal('show');
            }
        }

    </script>

    <r:require module="fileuploader" />

    <script type="text/javascript">
    /*
        var au_imageUploader = new qq.FileUploader({
            element: document.getElementById('au-imageUploader'),
            action: '/ticbox/survey/uploadImage',
            params: {
                surveyorId: 27
            },
            onComplete: function(id, fileName, responseJSON) {
                $('.profile-pic').attr('src', 'data:image;base64,' + responseJSON.img);
                $('.qq-upload-list').empty()
            }
        });
     */
    </script>

</head>
<body>

<div class="module">
    <div class="module-header">
        <div class="title">
            <span style="color: black; font-weight: normal">Edit Survey: </span>
            <span style="text-transform: uppercase">${survey.name}</span>
        </div>
    </div>
    <div class="module-content">
        <div class="panel panel-default">
            <div class="panel-heading" style="padding: 20px 15px">
                <div class="media">
                    <div id="surveyLogo" class="pull-left clickable survey-logo" data-toggle="modal" href="#chooseLogoModal">
                        <g:if test="${survey[Survey.COMPONENTS.LOGO]}">
                            <img class="media-object img-responsive"
                             style="background: #f5f5f5; min-height: 148px; min-width: 148px;"
                             src="${request.contextPath}/survey/viewLogo?resourceId=${survey[Survey.COMPONENTS.LOGO]}" data-image-id="${survey[Survey.COMPONENTS.LOGO]}">
                        </g:if>
                        <g:else>
                            <img class="media-object img-responsive"
                                 style="background: #f5f5f5 url('../images/ticbox/Logo_Placeholder.png') no-repeat center center; min-height: 148px; min-width: 148px;"
                                 src="${request.contextPath}/survey/viewLogo?resourceId=${survey[Survey.COMPONENTS.LOGO]}" data-image-id="${survey[Survey.COMPONENTS.LOGO]}">
                        </g:else>
                    </div>
                    <div class="media-body">
                        <span style="font-size: 18px;">
                            <g:message code="label.survey.survey-generator.survey-title" default="Describe Your Survey"/>
                        </span>
                        <div>
                            <textarea id="surveyTitle" rows="4" class="form-control" style="resize: none; margin: 14px 10px 0 0"></textarea>
                        </div>
                    </div>
                </div>
            </div>
            <div class="surveyItemsContainer enableTooltip panel-body" style="padding: 20px 15px 20px 10px">
            </div>

    </div>
        <div id="menuQuestionType">

            %{--<div id="questionTypesMenuContainer" class="side-panel">--}%
            <div id="questionTypesMenuContainer" >
                <div id="questionTypesItemContainer">
                    <ul>
                        <li class="surveyItemTypeAdd single-choice clickable" type="${Survey.QUESTION_TYPE.CHOICE_SINGLE}" subtype="single"></li>
                        <li class="surveyItemTypeAdd multiple-choice clickable" type="${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}" subtype="multiple"></li>
                        <li class="surveyItemTypeAdd single-text clickable" type="${Survey.QUESTION_TYPE.FREE_TEXT}"></li>
                        <li class="surveyItemTypeAdd scale clickable" type="${Survey.QUESTION_TYPE.SCALE_RATING}"></li>
                        <li class="surveyItemTypeAdd star-rating clickable" type="${Survey.QUESTION_TYPE.STAR_RATING}"></li>

                        %{--<li id="questionTypesTitleContainer"></li>--}%
                        <li id="questionTypesDynamicTitleContainer">
                            <span id="question-type-title"><g:message code="survey.choose-question-type"/></span>
                            <span id="single-choice-title">Single Choice</span>
                            <span id="multiple-choice-title" style="font-size: 1em !important;">Multiple Choice</span>
                            <span id="free-text-title">Free Text</span>
                            <span id="scale-title">Scale Rating</span>
                            <span id="star-rating-title">Star Rating</span>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="" style="width: 100%">
                <div class="line line-centered">
                    <button style="border-radius: 8px; width: 100%;" href="#surveyPreviewModal" role="button" data-toggle="modal" class="btn btn-lg btn-blue-trust" type="button"><g:message code="label.button.preview" default="Quick Preview"/> Survey</button>
                </div>
            </div>
        </div>
    <div id="buttonBarHeader" class="module-header"></div>
        <div id="buttonBarContent" class="module-content">
            <button class="btn btn-sm btn-light-oak link" href="${request.contextPath}/survey/editSurvey?surveyId=${survey.surveyId}"><g:message code="label.button.back" default="Back"/></button>
            <%--a class="btn btn-danger" surveyid="${survey.surveyId}" href="${request.contextPath}/survey/editSurvey?surveyId=${survey.surveyId}">Back</a--%>
            <button id="saveSurveyBtn" class="btn btn-sm btn-green"><g:message code="label.button.save" default="Save"/></button>
            <%--button id="finalizeSurveyBtn" class="btn btn-sm btn-blue-trust link" href="#submit-confirmation-modal"><g:message code="label.button.submit" default="Submit"/></button--%>
            %{--<a id="finalizeSurveyBtn2" href="#submit-confirmation-modal" role="button" class="btn btn-sm btn-blue-trust link" data-toggle="modal"><i class="icon-remove icon-white"></i> Submit</a>--}%
            <a id="finalizeSurveyBtn" role="button" class="btn btn-sm btn-blue-trust link" data-toggle="modal"><i class="icon-remove icon-white"></i> <g:message code="label.button.submit" /></a>
        </div>
    </div>
</div>

<div id="menuNavPanelContent">


</div>

<div class="templates" style="display: none;">

    <div id="questionTemplate" class="surveyItemContainer">
        <div class="row question-row" style="position: relative">
            <div class="seqNumberContainer questionNumber col-xs-1"></div>
            <div class="col-xs-11">
                <div class="questionTextContainer">
                    <textarea class="form-control" style="padding: 6px 12px; word-wrap: break-word" rows="3" placeholder="${message([code: 'message.type-to-set-question', default: 'Type your question here..'])}" maxlength="1500"></textarea>
                    <div class="question-action-btn change-question-type-btn" style="position: absolute;right: 10px;top: 8px;"></div>
                </div>
                <div class="surveyItemActions" style="float: left; padding: 1px 0 0 5px">
                    %{--<div>--}%
                    %{--<button class="btn video" data-toggle="tooltip" data-placement="top" title="Upload video"><i class="icon-play"></i></button>--}%
                    %{--<div class="question-action-btn change-question-type-btn" style="display: inline-block"></div>--}%
                    %{--<button class="btn remove" data-toggle="tooltip" data-placement="top" title="Remove"><i class="icon-remove"></i></button>--}%
                    %{--<div class="remove question-action-btn delete-question-icon clickable" style="display: inline-block"></div>--}%
                    %{--</div>--}%
                    %{--<div>--}%
                    %{--<button class="btn picture" data-toggle="tooltip" data-placement="top" title="Upload picture"><i class="icon-camera"></i></button>--}%

                    %{--<button class="btn remove" data-toggle="tooltip" data-placement="top" title="Remove"><i class="icon-remove"></i></button>--}%
                    %{--</div>--}%
                    <div class="question-action-btn upload-pic-icon clickable" style="margin: 0 0 0 0">
                        <span class="media-thumbnail"></span>
                        <img class="pic upload-pic" src="" style="width: auto; height: 30px; margin-left: 30px;"/>
                        <input type="hidden" class="image-id" val=""/>
                    </div>
                </div>
            </div>
            <div class="surveyItemActions" style="position: absolute; right: 10px;top: 0;">
                <div class="remove question-action-btn delete-question-icon clickable"></div>
                <div class="up question-action-btn up-question-icon clickable" style="margin-right: 0px"></div>
                <div class="down question-action-btn down-question-icon clickable" style="margin-right: 0px"></div>
            </div>
        </div>

    </div>

    <div id="answerTemplate-singleText" class="answerTemplate row" type="${Survey.QUESTION_TYPE.FREE_TEXT}">
        <div class="col col-xs-11 col-xs-offset-1">
            <textarea class="place-holder-text form-control answerTextContainer" rows="3" placeholder="${message([code: 'message.type-to-replace-place-holder', default: 'Type here to change this placeholder..'])}"></textarea>
        </div>
    </div>

    <div id="answerTemplate-choice-single" class="answerTemplate row" type="${Survey.QUESTION_TYPE.CHOICE_SINGLE}">

        <div class="choice-items col col-xs-11 col-xs-offset-1">
            <div class="choice-item row" style="margin-bottom: 3px">
                    <input class="item-check" type="checkbox" checked style="height: 34px">
                    <input class="item-label form-control" type="text" placeholder="${message([code: 'message.type-to-set-label', default: 'Type here to set label..'])}" maxlength="100">
                    <div class="col" style="float: left; padding: 1px 0 0 5px">
                        %{--<button class="btn" data-toggle="tooltip" data-placement="right" title="Upload picture"><i class="icon-camera"></i></button>--}%
                        %{--<div style="width: 20px; height: 100%; cursor: pointer; background: transparent url('../images/ticbox/06_Question_UploadIcon_Picture.png') no-repeat center"></div>--}%
                        <div class="question-action-btn upload-pic-icon clickable" style="margin: 0 0 0 0">
                            <span class="media-thumbnail"></span>
                            <img class="pic upload-pic" src="" style="width: auto; height: 30px; margin-left: 30px;"/>
                            <input type="hidden" class="image-id" val=""/>
                        </div>
                    </div>
            </div>
        </div>
        <div class="form-group col col-xs-11 col-xs-offset-1" style="clear: both; width: 100%; padding: 5px 15px 0">
            <div class="col" style="display: none;">
                <select class="choice-type">
                    <option value="single">Single Choice</option>
                </select>
            </div>
            <div class="col">
                <button class="btn btn-default btn-info add-item"><i class="glyphicon glyphicon-plus"></i> New Item</button>

            </div>
        </div>
    </div>

    <div id="answerTemplate-choice-multiple" class="answerTemplate row" type="${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}">

        <div class="choice-items col col-xs-11 col-xs-offset-1">
            <div class="choice-item row" style="margin-bottom: 3px">
                <input class="item-check" type="checkbox" checked style="height: 34px">
                <input class="item-label form-control" type="text" placeholder="${message([code: 'message.type-to-set-label', default: 'Type here to set label..'])}" maxlength="100">
                <div class="col" style="float: left; padding: 1px 0 0 5px">
                    %{--<button class="btn" data-toggle="tooltip" data-placement="right" title="Upload picture"><i class="icon-camera"></i></button>--}%
                    %{--<div style="width: 20px; height: 100%; cursor: pointer; background: transparent url('../images/ticbox/06_Question_UploadIcon_Picture.png') no-repeat center"></div>--}%
                    <div class="question-action-btn upload-pic-icon clickable" style="margin: 0 0 0 0">
                        <span class="media-thumbnail"></span>
                        <img class="pic upload-pic" src="" style="width: auto; height: 30px; margin-left: 30px;"/>
                        <input type="hidden" class="image-id" val=""/>
                    </div>
                </div>
            </div>
        </div>
        <div class="form-group col col-xs-11 col-xs-offset-1" style="clear: both; width: 100%; padding: 5px 15px 0">
            <div class="col" style="display: none;">
                <select class="choice-type">
                    <option value="single">Single Choice</option>
                </select>
            </div>
            <div class="col">
                <button class="btn btn-default btn-info add-item"><i class="glyphicon glyphicon-plus"></i> New Item</button>

            </div>
        </div>
    </div>

    <div id="answerTemplate-scale" class="answerTemplate row" type="${Survey.QUESTION_TYPE.SCALE_RATING}">
        %{--<div class="col col-xs-12" style="height:auto; overflow-x: auto; max-width: 600px;">--}%
        <div class="col col-xs-11 col-xs-offset-1">
            <div class="scale-table-container" style="overflow-x: auto;">
                %{--<div class="seqNumberContainer">&nbsp;</div>--}%
                <table class="survey-generator-table table scale-table table-responsive" style="width: auto">
                    <thead>
                        <tr class="scale-head">
                            <th class="col-sm-3 form-inline" style="text-align: left; width: 100px; display: inline">
                            </th>
                            <th class="rating-label" style="text-align: left">
                                <input type="text" class="input-small form-control" placeholder="<g:message code="message.rating-to-set-label"/>" style="width: 100px;" maxlength="50">
                            </th>
                            <th style="white-space:nowrap;">
                                <button class="btn btn-default btn-info remove-rating">
                                    <i class="glyphicon glyphicon-minus"></i>
                                </button>

                                <button class="btn btn-default btn-info add-rating">
                                    <i class="glyphicon glyphicon-plus"></i> Rating
                                </button>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="scale-row">
                            <td style="max-width: 100px;">
                                <input type="text" class="row-label input-small form-control" placeholder="<g:message code="message.row-to-set-label"/>" style="width: 100%;" maxlength="50">
                            </td>
                            <td class="rating-weight" style="text-align: center">
                                <input type="radio" name="rd-1">
                            </td>
                            <td></td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td style="white-space:nowrap; max-width: 500px;">
                                <button class="btn btn-default btn-info remove-row">
                                    <i class="glyphicon glyphicon-minus"></i>
                                </button>
                                <button class="btn btn-default btn-info add-row">
                                    <i class="glyphicon glyphicon-plus"></i> Row
                                </button>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>

    <div id="answerTemplate-starRating" class="answerTemplate row" type="${Survey.QUESTION_TYPE.STAR_RATING}">
        <div class="line stars col col-xs-11 col-xs-offset-1">
            <div class="col star clickable"></div>
            <div class="col star clickable"></div>
            <div class="col star clickable"></div>
            <div class="col star clickable"></div>
            <div class="col star clickable"></div>
        </div>
        <div class="line col col-xs-11 col-xs-offset-1 form-group" style="clear: both; width: 100%; padding: 5px 15px 0">
            <div class="col" style="margin-right: 5px">
                <button class="btn btn-default btn-info remove-star">
                    <i class="glyphicon glyphicon-minus"></i>
                </button>
            </div>
            <div class="col">
                <button class="btn btn-default btn-info add-star">
                    <i class="glyphicon glyphicon-plus"></i>
                </button>
            </div>
        </div>
    </div>

    %{--Preview Templates--}%

    <div id="questionPreviewTemplate" class="surveyItemContainer">
        <div class="row">
            <div class="seqNumberContainer questionNumber col-xs-1"> </div>
            <div class="questionTextContainer col-xs-11">
                <span class="question-text"></span>
            </div>
            <!-- sanchez -->
            <span class="media-thumbnail">
                <img class="pic upload-pic" src="" />
            </span>
        </div>
    </div>

    <div id="answerPreviewTemplate-singleText" class="answerTemplate row" type="${Survey.QUESTION_TYPE.FREE_TEXT}">
        <div class="col col-xs-11 col-xs-offset-1">
            <textarea class="form-control" rows="3" placeholder="" style="width: 100% !important;" maxlength="1500"></textarea>
        </div>
    </div>

    <div id="answerPreviewTemplate-multipleChoice" class="answerTemplate row" type="${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}">
        <div class="choice-items col-xs-11 col-xs-offset-1">
            <div class="choice-item row">
                %{--<label class="checkbox">--}%
                %{--<div class="col col-xs-1" style="text-align: right">--}%
                <div class="col col-xs-12">
                    <input class="item-check" type="checkbox">
                %{--</div>--}%
                %{--<div class="col col-xs-11" style="padding-left: 0">--}%
                    <span class="item-label" style="font-weight: normal; margin-bottom: 0"></span>
                    <!-- sanchez -->
                    <span class="media-thumbnail">
                        <img class="pic upload-pic" src="" />
                    </span>
                </div>
                %{--</label>--}%
            </div>
        </div>
    </div>

    %{--<div id="answerPreviewTemplate-singleChoice" class="answerTemplate row" type="${Survey.QUESTION_TYPE.CHOICE}">--}%
        %{--<div class="col col-xs-11 col-xs-offset-1">--}%
            %{--<select class="item-select" style="min-width: 200px">--}%
                %{--<option></option>--}%
            %{--</select>--}%
        %{--</div>--}%
    %{--</div>--}%

    <div id="answerPreviewTemplate-singleChoice" class="answerTemplate row" type="${Survey.QUESTION_TYPE.CHOICE_SINGLE}">
        <div class="choice-items col-xs-11 col-xs-offset-1">
            <div class="choice-item row">
                %{--<div class="col col-xs-1" style="text-align: right">--}%
                <div class="col col-xs-12">
                    <input class="item-check" type="radio">
                %{--</div>--}%
                %{--<div class="col col-xs-11" style="padding-left: 0">--}%
                    <span class="item-label" style="font-weight: normal; margin-bottom: 0"></span>
                    <!-- sanchez -->
                    <span class="media-thumbnail">
                        <img class="pic upload-pic" src="" />
                    </span>
                </div>
            </div>
        </div>
    </div>

    <div id="answerPreviewTemplate-scale" class="answerTemplate row" type="${Survey.QUESTION_TYPE.SCALE_RATING}">
        <div class="col col-xs-11 col-xs-offset-1" style="overflow-x: auto;width: auto">
            <table class="table scale-table table-bordered table-responsive">
                <thead>
                    <tr class="scale-head">
                        <th style="text-align: center;"></th>
                        %{--<th class="rating-label" style="text-align: center"></th>--}%
                    </tr>
                </thead>
                <tbody>
                <tr class="scale-row">
                    <td class="row-label"> </td>
                    <td class="rating-weight" style="text-align: center">
                        <input type="radio" name="rd-1">
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div id="answerPreviewTemplate-starRating" class="answerTemplate row" type="${Survey.QUESTION_TYPE.STAR_RATING}">
        <div class="line stars col-xs-11 col-xs-offset-1">

        </div>
    </div>

    <div class="logoWrapper col">
        <div class="col clickable" style="border: 1px solid #cccccc; border-radius: 10px; width: 100px">
            <img class="logoImg" src="" style="width: 100%; border-radius:10px">
        </div>
        <div class="line line-centered" style="margin: 10px auto;">
            <input type="radio" name="logoResourceId" class="logoResourceId">
        </div>
    </div>

    <div class="nextQuestionWrapper row">
        <div class="seqNumberContainer col-xs-1 questionNumber">
        </div>
        <div class="line line-centered" style="margin: 10px auto;">
            <input type="radio" name="nextQuestionId" class="nextQuestionId">
        </div>
    </div>

</div>

<!-- Preview Modal -->
<div id="surveyPreviewModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="surveyPreviewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="surveyPreviewModalLabel" class="modal-title" >Survey Preview</span>
            </div>
            <div class="modal-body" style="overflow: auto; padding: 20px 50px 20px 20px">

            </div>
            <div class="modal-footer">
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close" default="Close"/></button>
            </div>
        </div>
    </div>
</div>

%{--Upload image resource modal--}%
<div id="chooseLogoModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="chooseLogoModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="chooseLogoModalLabel" class="modal-title">
                    <g:message code="survey.logo.label"/>
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
            </div>
            <div class="modal-footer">
                <button id="pickLogoBtn" class="btn btn-light-oak"><g:message code="app.pick.label"/></button>
                <button id="uploadLogoBtn" class="btn btn-green"><g:message code="app.upload.label"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close" default="Close"/></button>
            </div>
        </div>
    </div>
</div>

%{--Upload image resource modal--}%
<div id="chooseImageModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="chooseImageModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="chooseImageModalLabel" class="modal-title">
                    User Image Resources
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
            </div>
            <div class="modal-footer">
                <button id="pickImageBtn" class="btn btn-light-oak"><g:message code="app.pick.label"/></button>
                <button id="uploadImageBtn" class="btn btn-green"><g:message code="app.upload.label"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close" default="Close"/></button>
            </div>
        </div>
    </div>
</div>

<div id="previewImageModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="previewImageModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="previewImageModalLabel" class="modal-title">
                    Image Uploaded
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
                <div class="logoWrapper col">
                    <div class="col clickable" style="border: 1px solid #cccccc; border-radius: 10px; width: 100%">
                        <img class="logoImg" src="" style="width: 100%; border-radius:10px">
                        <input type="hidden" id="uploadedImageResId"/>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button id="confirmImageBtn" class="btn btn-light-oak">OK</button>
            </div>
        </div>
    </div>
</div>

<!-- Single Question Next Modal -->
<div id="singleQuestionNextModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby=singleQuestionNextModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="singleQuestionNextModalLabel" class="modal-title" ><g:message code="app.nextquestion.label"/></span>
            </div>
            <div class="modal-body" style="overflow: auto;">
                <span>hello world</span>

            </div>
            <div class="modal-footer">
                <button class="btn btn-light-oak nextButton"><g:message code="app.select.label"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close" default="Close"/></button>
            </div>
        </div>
    </div>
</div>

<!-- Submit Confirmation Modal -->
<div id="submit-confirmation-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="submitConfirmationLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="enableSurveyLabel" class="modal-title">
                    Submit Confirmation
                </span>
            </div>
            <div class="modal-body">
                <g:form name="enableSurveysForm" controller="admin" action="enableSurveys" role="form">
                    <input type="hidden" id="enableSurveyIds" name="enableSurveyIds" value=""/>
                    <div class="well">
                        <p><b><g:message code="survey.submitsurvey.label"/></b></p>
                        <g:message code="survey.submitsurvey.content"/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="submitConfirmation" onclick="saveAndSubmitSurvey();" class="btn btn-danger" data-loading-text="Processing.."><g:message code="app.submit.label"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>
</div>

<!-- Validate Question Items modal -->
<div id="validate-question-items-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="validateQuestionItemsLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="validateQuestionItemsLabel" class="modal-title">
                    <g:message code="survey.question.validate.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="validateQuestionItemsForm" role="form">
                    <div class="well">
                        <p><b><g:message code="survey.validate.failed.label"/></b></p>
                        <g:message code="survey.validate.failed.content"/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="validateQuestionItemsBtn" class="btn btn-danger" data-dismiss="modal" aria-hidden="true"><g:message code="app.ok.label"/></button>
            </div>
        </div>
    </div>
</div>
<!-- Validate Choice Question Items modal -->
<div id="validate-choice-question-items-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="validateChoiceQuestionItemsLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="validateChoiceQuestionItemsLabel" class="modal-title">
                    <g:message code="survey.validate.choice.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="validateQuestionItemsForm" role="form">
                    <div class="well">
                        <p><b><g:message code="survey.validate.choice.failed.label"/></b></p>
                        <g:message code="survey.validate.choice.failed.content"/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="validateChoiceQuestionItemsBtn" class="btn btn-danger" data-dismiss="modal" aria-hidden="true"><g:message code="app.ok.label"/></button>
            </div>
        </div>
    </div>
</div>
<!-- Validate Scale Rating Question Items modal -->
<div id="validate-matrix-question-items-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="validateScaleQuestionItemsLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="validateScaleQuestionItemsLabel" class="modal-title">
                    <g:message code="survey.validate.rating.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="validateScaleQuestionItemsForm" role="form">
                    <div class="well">
                        <p><b><g:message code="survey.validate.rating.failed.label"/></b></p>
                        <g:message code="survey.validate.rating.failed.content"/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="validateScaleQuestionItemsBtn" class="btn btn-danger" data-dismiss="modal" aria-hidden="true"><g:message code="app.ok.label"/></button>
            </div>
        </div>
    </div>
</div>

<div style="display: none">
    <uploader:uploader id="imageUploader" url="${[controller:'survey', action:'uploadLogo']}" params="${[resType:'LOGO']}" sizeLimit="512000"> %{--allowedExtensions="['jpeg', 'png', 'gif']"--}%
        <uploader:onComplete>
            if(responseJSON.resourceId){
                populateLogoImageResources(responseJSON.resourceId);
            }else{
                alert(responseJSON.message);
            }
        </uploader:onComplete>
    </uploader:uploader>
</div>

<div style="display: none">
    <uploader:uploader id="surveyItemImageUploader" url="${[controller:'survey', action:'uploadLogo']}" params="${[resType:'IMAGE']}" sizeLimit="512000"> %{--allowedExtensions="['jpeg', 'png', 'gif']"--}%
        <uploader:onComplete>
            if(responseJSON.resourceId){
                //For gallery
                //populateImageResources(responseJSON.resourceId);

                //For temp container
                var modal = jQuery('#previewImageModal');
                jQuery('#uploadedImageResId').val(responseJSON.resourceId);
                jQuery('img.logoImg', modal).attr('src', '${request.contextPath}/survey/viewResources?resType=IMAGE&resourceId='+responseJSON.resourceId)
                modal.modal('show');

                jQuery('#au-surveyItemImageUploader .qq-upload-button > input').val('');
            }else{
                alert(responseJSON.message);
            }

            hide_loader();
        </uploader:onComplete>
    </uploader:uploader>
</div>

</body>
</html>