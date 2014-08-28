package ticbox

import grails.transaction.Transactional

@Transactional
class EmailService {

    def deleteEmails(String[] ids) throws Exception {
        List<Long> delIds = HelperService.getListOfLong(ids)
        def emails = Email.findAll{
            inList("_id", delIds)
        }
        if (emails) {
            Email.deleteAll(emails)
        } else {
            throw new Exception("No Email was found")
        }
    }
}
