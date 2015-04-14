// locations to search for config files that get merged into the main config;
// config files can be ConfigSlurper scripts, Java properties files, or classes
// in the classpath in ConfigSlurper format

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if (System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [
    all:           '*/*',
    atom:          'application/atom+xml',
    css:           'text/css',
    csv:           'text/csv',
    form:          'application/x-www-form-urlencoded',
    html:          ['text/html','application/xhtml+xml'],
    js:            'text/javascript',
    json:          ['application/json', 'text/json'],
    multipartForm: 'multipart/form-data',
    rss:           'application/rss+xml',
    text:          'text/plain',
    xml:           ['text/xml', 'application/xml']
]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// What URL patterns should be processed by the resources plugin
grails.resources.adhoc.patterns = ['/images/*', '/css/*', '/js/*', '/plugins/*']

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
// whether to disable processing of multi part requests
grails.web.disable.multipart=false

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// configure auto-caching of queries by default (if false you can cache individual queries with 'cache: true')
grails.hibernate.cache.queries = false

grails.plugins.remotepagination.max=10
//EnableBootstrap here when using twitter bootstrap, default is set to false.
grails.plugins.remotepagination.enableBootstrap=true

environments {
    development {
        grails.logging.jul.usebridge = true
        grails.serverURL = "http://localhost:8080/${appName}"
        oauth {
            providers {
                facebook {
                    api = org.scribe.builder.api.FacebookApi
                    key = '340671472720583'
                    secret = 'ff76857c8b5f40802bc2256fb089b7c6'
                    callback = "${grails.serverURL}/oauth/facebook/callback"
                    successUri = '/oauth/success?provider=facebook&targetUri=%2F'
                    failureUri = '/auth/unauthorized'
                }

                twitter {
                    api = org.scribe.builder.api.TwitterApi
                    key = '7mNrsJTT4Yte4fNeWk8Q'
                    secret = 'rbQSxzjKaiZ12JOcRyR0dQwS5DfAYCC0rVzFujSjEGI'
                    callback = "${grails.serverURL}/oauth/twitter/callback"
                    successUri = '/oauth/success?provider=twitter&targetUri=%2F'
                    failureUri = '/auth/unauthorized'
                }

                google {
                    api = org.scribe.builder.api.GoogleApi
                    key = '500869118614.apps.googleusercontent.com'
                    secret = 'Z-M6KLCqu3oOzyX2DquE5Tup'
                    scope = 'https://www.googleapis.com/auth/userinfo.profile'
                    callback = "${grails.serverURL}/oauth/google/callback"
                    successUri = '/oauth/success?provider=google&targetUri=%2F'
                    failureUri = '/auth/unauthorized'
                }
            }
        }
    }
    production {
        grails.logging.jul.usebridge = false
        oauth {
            providers {
                facebook {
                    api = org.scribe.builder.api.FacebookApi
                    key = '158637827627767'
                    secret = '2e8c39744b4637ad55154cb51032207e'
                    callback = "http://ticbox.herokuapp.com/oauth/facebook/callback"
                    successUri = '/oauth/success?provider=facebook&targetUri=%2F'
                    failureUri = '/auth/unauthorized'
                }

                twitter {
                    api = org.scribe.builder.api.TwitterApi
                    key = 'oWN2WVrBaZn9uXfGmNWaLA'
                    secret = 'oLHsHOtaPFZHkAoY2TkEWf98I35AlHXhHAkcxnibE'
                    callback = "http://ticbox.herokuapp.com/oauth/twitter/callback"
                    successUri = '/oauth/success?provider=twitter&targetUri=%2F'
                    failureUri = '/auth/unauthorized'
                }

                google {
                    api = org.scribe.builder.api.GoogleApi
                    key = '500869118614-gqp3b95u0iv1dplimj7vmc66mkrmjcpo.apps.googleusercontent.com'
                    secret = '5iMP5v8LViQQhmgLro9U3_24'
                    scope = 'https://www.googleapis.com/auth/userinfo.profile'
                    callback = "http://ticbox.herokuapp.com/oauth/google/callback"
                    successUri = '/oauth/success?provider=google&targetUri=%2F'
                    failureUri = '/auth/unauthorized'
                }

            }
        }
    }
}

security.shiro.oauth.linkAccountUrl = "/auth/linkAccount"

// enable remember me
security.shiro.authc.required = false

// log4j configuration
log4j = {
    // Example of changing the log pattern for the default console appender:
    //
    appenders {
        console name:'stdout', layout:pattern(conversionPattern: '%c{2} %m%n')
    }

    error  'org.codehaus.groovy.grails.web.servlet',        // controllers
           'org.codehaus.groovy.grails.web.pages',          // GSP
           'org.codehaus.groovy.grails.web.sitemesh',       // layouts
           'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
           'org.codehaus.groovy.grails.web.mapping',        // URL mapping
           'org.codehaus.groovy.grails.commons',            // core / classloading
           'org.codehaus.groovy.grails.plugins',            // plugins
           'org.codehaus.groovy.grails.orm.hibernate',      // hibernate integration
           'org.springframework',
           'org.hibernate',
           'net.sf.ehcache.hibernate'
}

grails {
    mail {
        host = "smtp.gmail.com"
        port = 465
        username = "ticbox.info@gmail.com"
        password = "ticboxinfo123"
        props = ["mail.smtp.auth":"true",
                "mail.smtp.socketFactory.port":"465",
                "mail.smtp.socketFactory.class":"javax.net.ssl.SSLSocketFactory",
                "mail.smtp.socketFactory.fallback":"false"]
    }
}
// Uncomment and edit the following lines to start using Grails encoding & escaping improvements

/* remove this line 
// GSP settings
grails {
    views {
        gsp {
            encoding = 'UTF-8'
            htmlcodec = 'xml' // use xml escaping instead of HTML4 escaping
            codecs {
                expression = 'html' // escapes values inside null
                scriptlet = 'none' // escapes output from scriptlets in GSPs
                taglib = 'none' // escapes output from taglibs
                staticparts = 'none' // escapes output from static template parts
            }
        }
        // escapes all not-encoded output at final stage of outputting
        filteringCodecForContentType {
            //'text/html' = 'html'
        }
    }
}
remove this line */

