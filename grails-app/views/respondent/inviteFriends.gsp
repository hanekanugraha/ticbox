<html>
<head>
    <meta name="layout" content="respondent"/>
    <title><g:message code="invitefriends.title"/></title>
    <style type="text/css">


    </style>
</head>

<body>
    <div id="inviteFriendsHeader" class="module-header">
        <div class="title"><g:message code="invitefriends.title"/></div>
        <div style="font-weight: normal; font-size: 12px"><g:message code="invitefriends.label"/></div>
    </div>
    <div id="inviteFriendsForm" class="module-content">
        <div class="message-box">
            <div class="module-message">
                <g:message code="invitefriends.1gold.label"/>
            </div>
        </div>

        <div class="row" style="margin: 20px 0 30px; padding-bottom: 20px; border-bottom: 1px solid #E8E8E8;">
            <div style="color: #6daac9; font-weight: bold"><g:message code="invitefriends.refer.label"/>
                <span style="font-weight: bold; font-size: 16px; color: black;">${respondent.respondentProfile.references.size()}</span>
                <g:message code="invitefriends.totalfriends.label"/>
            </div>
        </div>

        <h4><g:message code="invitefriends.referencelink.label"/> </h4>
        <div class="row">
            <div class="col-xs-10">
                <div class="input-append">
                    <input id="refLink" class="form-control input-xxlarge" type="text" value="${refLink}" disabled="disabled" style="display: inline-block;"/>
                    <button id="copyRefLink" class="btn btn-lg btn-light-oak" style="border-top-right-radius: 15px; border-bottom-right-radius: 15px; padding: 3px 15px 5px 12px; box-shadow: 0 10px 2px 0 rgba(255, 255, 255, 0.2) inset;"><i class="glyphicon glyphicon-book"></i> <g:message code="app.copy.label"/> </button>
                </div>
            </div>
        </div>

        <h4><g:message code="invitefriends.email.label"/> </h4>
        <g:form name="inviteForm" class="form-horizontal">
            <textarea id="friendEmails" name="friendEmails" rows="4" class="form-control input-xxlarge"></textarea>
            <label style="color:#a0a0a0"><g:message code="invitefriends.separator.label"/> </label>
        </g:form>

        <button id="submitRequest" class="btn btn-default btn-green">${g.message(code: 'app.submit.label')}</button>

        <br /><br />

        <h4><g:message code="invitefriends.socialmedia.label"/> </h4>
        <div class="row">
            <div class="col-xs-12">
                <button id="inviteByFacebookWall" class="btn btn-default btn-sm"><i class="icon-fb"></i> <g:message code="invitefriends.socialmedia.postwall.label"/></button>
                <a id="inviteByFacebookDM" class="btn btn-default btn-sm"><i class="icon-fb"></i> <g:message code="invitefriends.socialmedia.sendmessage.label"/></a>
                <a id="inviteByTwitterTweet" class="btn btn-default btn-sm"><i class="icon-tw"></i> <g:message code="invitefriends.socialmedia.sendtweet.label"/></a>
                <a id="inviteByTwitterDM" class="btn btn-default btn-sm"><i class="icon-tw"></i> <g:message code="invitefriends.socialmedia.directmessage.label"/></a>
            </div>
        </div>
    </div>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<g:javascript src="jquery.zclip.min.js"/>

<script src="http://connect.facebook.net/en_US/all.js"></script>
<div id="fb-root"></div>

<script type="text/javascript">

    function submitRequest(btn) {
        var form = $('#inviteForm');
        if(form.valid()) {
            jQuery(btn).attr('disabled', 'disabled');
            var url = '${g.createLink(controller: "respondent", action: "inviteByEmail")}';
            var data = form.serialize();
            $.post(url, data, function(response) {
                var message = (response == 'SUCCESS') ? 'Invitations sent' : 'Failed to send email';
                alert(message);
                jQuery(btn).removeAttr('disabled');
            });
        }
    }

    $(document).ready(function () {

        // init FB API
        FB.init({appId: ${fbAppId}, xfbml: true, cookie: true});

        $('#copyRefLink').zclip({
            path: '${g.resource(dir: "js", file: "ZeroClipboard.swf")}',
            copy: $('#refLink').val()
        });

        $('#submitRequest').click(function() {
            submitRequest(this);
        });

        $('#inviteByFacebookWall').click(function() {
            FB.ui(
                    {
                        method: 'feed',
                        name: '${g.message(code: "ticbox.respondent.invite.facebook.wall.name")}',
                        link: 'https://developers.facebook.com/docs/reference/dialogs/',
                        picture: 'http://fbrell.com/f8.jpg',
                        caption: '${g.message(code: "ticbox.respondent.invite.facebook.wall.caption")}',
                        description: '${g.message(code: "ticbox.respondent.invite.facebook.wall.description")}'
                    },
                    function(response) {
                        if (response && response.post_id) {
                            alert('Post was published.');
                        } else {
                            alert('Post was not published.');
                        }
                    }
            );
        });

        $('#inviteByFacebookDM').click(function() {
            FB.ui({
                method: 'send',
                link: '${refLink}'
            });
        });

        $('#inviteByTwitterTweet')
                .attr('href', 'https://twitter.com/share?url=${refLink}&text=${g.message(code:"ticbox.respondent.invite.twitter.tweet.text")}')
                .attr('target', '_blank');

        $('#inviteByTwitterDM')
                .attr('href', 'https://twitter.com/direct_messages/')
                .attr('target', '_blank');

        $('#inviteForm').validate({
            rules: {
                friendEmails: {
                    required: true,
                    minlength: 7
                }
            }
        });
    });

</script>
</body>
</html>