package ticbox

class BootstrapService {

    def servletContext
    def serviceMethod() {

    }

    def init(){
        try {
            initLookupMaster()
            initProfileItems()
        }catch (Exception e){
            e.printStackTrace()
        }
    }

    def initUpdate(){
        try {
            complementProfileItems()
        }catch (Exception e){
            e.printStackTrace()
        }
    }

    def destroy(){

    }

    def initLookupMaster(){

        if (LookupMaster.all.empty) {
            new LookupMaster(
                    code: 'LM_COUNTRIES001',
                    label: 'Countries',
                    values: [
                            ID : 'Indonesia',
                            MY : 'Malaysia',
                            SG : 'Singapore'
                    ]
            ).save()

            new LookupMaster(
                    code: 'LM_EDU001',
                    label: 'Education',
                    values: [
                            NO_COLLEGE : 'No College',
                            SOME_COLLEGE : 'Some College',
                            TWO_YR_DEGREE : 'Two Year Degree',
                            FOUR_YR_DEGREE : 'Four Year Degree',
                            GRAD_SCHOOL_DEGREE: 'Grad School Degree',
                            PROFESSIONAL_DEGREE:'Professional Degree'
                    ]
            ).save()

//            new LookupMaster(
//                    code: 'LM_DUMMY001',
//                    label: 'Dummy',
//                    values: [
//                            DMY1 : 'Dummy Item 1',
//                            DMY2 : 'Dummy Item 2',
//                            DMY3 : 'Dummy Item 3',
//                            DMY4 : 'Dummy Item 4',
//                            DMY5 : 'Dummy Item 5',
//                    ]
//            ).save()

            new LookupMaster(
                    code: 'LM_RELIGION001',
                    label: 'Religion',
                    values: [
                            MOSLEM : 'Moslem',
                            CHRISTIAN : 'Christian',
                            CATHOLIC : 'Catholic',
                            BUDDHISM : 'Buddhism',
                            HINDUISM: 'Hinduism',
                            OTHERS:'Others'
                    ]
            ).save()

            new LookupMaster(
                    code: 'LM_EMP_STATUS001',
                    label: 'Employment Status',
                    values: [
                            FULLTIME : 'Full Time',
                            PARTTIME : 'Part Time',
                            RETIRED : 'Retired',
                            STUDENT : 'Student',
                            UNEMPLOYED: 'Unemployed'
                    ]
            ).save()

            new LookupMaster(
                    code: 'LM_CAREER001',
                    label: 'Career',
                    values: [
                            ACC_FINANCE_BANK : 'accounting/finance/banking',
                            ADV_GRP_DESIGN : 'advertising/graphic design',
                            ART_ENTERTAINMENT : 'arts/entertainment',
                            CLERICAL : 'clerical',
                            HEALTHCARE: 'healthcare',
                            HOSPITALITY: 'hospitality',
                            IT: 'IT',
                            LEGAL:  'legal',
                            MANAGEMENT: 'management',
                            MILITARY:   'military',
                            PUBLIC_SAFETY:  'public safety',
                            REAL_ESTATE:    'real estate',
                            RETAIL  :'retail',
                            SMALL_BSN_OWNER:    'small business owner',
                            STUDENT: 'student',
                            OTHERS: 'others'

                    ]
            ).save()

            new LookupMaster(
                    code: 'LM_GENDER001',
                    label: 'Gender',
                    values: [
                            MALE : 'Male',
                            FEMALE : 'Female'
                    ]
            ).save()

            new LookupMaster(
                    code: 'LM_RELATIONSHIP001',
                    label: 'Relationship Status',
                    values: [
                            SINGLE : 'Single',
                            ENGAGED : 'Engaged',
                            LVL_S_O: 'living with significant other',
                            MARRIED: 'Married',
                            DIVORCED:   'Divorced',
                            WIDOWED:    'Widowed',
                            COMPLICATED:    "It's Complicated"
                    ]
            ).save()

            new LookupMaster(
                    code: 'LM_PARENTAL_STATUS001',
                    label: 'Parental Status',
                    values: [
                            NO_CHILDREN : 'No Children',
                            ONE_CHILD : '1 Child',
                            TWO_CHILD : '2 Children',
                            THREE_CHILD : '3 Children',
                            FOUR_CHILD : '4 Children',
                            FIVEPLUS_CHILD : '5+ Children'
                    ]
            ).save()

            new LookupMaster(
                    code: 'LM_PROVINCE001',
                    label: 'Province',
                    values: [
                            ACEH:'Aceh',
                            BALI:'Bali',
                            BANTEN:'Banten',
                            BENGKULU:'Bengkulu',
                            GORONTALO:'Gorontalo',
                            JAKARTA:'Jakarta',
                            JAMBI:'Jambi',
                            JAWA_BARAT:'Jawa Barat',
                            JAWA_TENGAH:'Jawa Tengah',
                            JAWA_TIMUR:'Jawa Timur',
                            KALIMANTAN_BARAT:'Kalimantan Barat',
                            KALIMANTAN_SELATAN:'Kalimantan Selatan',
                            BANJARMASIN:'Banjarmasin',
                            KALIMANTAN_TENGAH:'Kalimantan Tengah',
                            KALIMANTAN_TIMUR:'Kalimantan Timur',
                            KALIMANTAN_UTARA:'Kalimantan Utara',
                            KEP_BANGKA_BELITUNG:'Kepulauan Bangka Belitung',
                            KEP_RIAU:'Kepulauan Riau',
                            LAMPUNG:'Lampung',
                            MALUKU:'Maluku',
                            MALUKU_UTARA:'Maluku Utara',
                            NTB:'Nusa Tenggara Barat',
                            NTT:'Nusa Tenggara Timur',
                            PAPUA:'Papua',
                            PAPUA_BARAT:'Papua Barat',
                            RIAU:'Riau',
                            SULAWESI_BARAT:'Sulawesi Barat',
                            SULAWESI_SELATAN:'Sulawesi Selatan',
                            MAKASSAR:'Makassar',
                            SULAWESI_TENGAH:'Sulawesi Tengah',
                            SULAWESI_TENGGARA:'Sulawesi Tenggara',
                            SULAWESI_UTARA:'Sulawesi Utara',
                            SUMATERA_BARAT:'Sumatera Barat',
                            SUMATERA_SELATAN:'Sumatera Selatan',
                            SUMATERA_UTARA:'Sumatera Utara',
                            YOGYAKARTA:'Yogyakarta'
                    ]
            ).save()

            new LookupMaster(
                    code: 'LM_CITY001',
                    label: 'City',
                    values: [
                            ACEH:'Aceh',
                            BALI:'Bali',
                            BANTEN:'Banten',
                            BENGKULU:'Bengkulu',
                            GORONTALO:'Gorontalo',
                            JAKARTA:'Jakarta',
                            JAMBI:'Jambi',
                            JAWA_BARAT:'Jawa Barat',
                            JAWA_TENGAH:'Jawa Tengah',
                            JAWA_TIMUR:'Jawa Timur',
                            KALIMANTAN_BARAT:'Kalimantan Barat',
                            KALIMANTAN_SELATAN:'Kalimantan Selatan',
                            BANJARMASIN:'Banjarmasin',
                            KALIMANTAN_TENGAH:'Kalimantan Tengah',
                            KALIMANTAN_TIMUR:'Kalimantan Timur',
                            KALIMANTAN_UTARA:'Kalimantan Utara',
                            KEP_BANGKA_BELITUNG:'Kepulauan Bangka Belitung',
                            KEP_RIAU:'Kepulauan Riau',
                            LAMPUNG:'Lampung',
                            MALUKU:'Maluku',
                            MALUKU_UTARA:'Maluku Utara',
                            NTB:'Nusa Tenggara Barat',
                            NTT:'Nusa Tenggara Timur',
                            PAPUA:'Papua',
                            PAPUA_BARAT:'Papua Barat',
                            RIAU:'Riau',
                            SULAWESI_BARAT:'Sulawesi Barat',
                            SULAWESI_SELATAN:'Sulawesi Selatan',
                            MAKASSAR:'Makassar',
                            SULAWESI_TENGAH:'Sulawesi Tengah',
                            SULAWESI_TENGGARA:'Sulawesi Tenggara',
                            SULAWESI_UTARA:'Sulawesi Utara',
                            SUMATERA_BARAT:'Sumatera Barat',
                            SUMATERA_SELATAN:'Sumatera Selatan',
                            SUMATERA_UTARA:'Sumatera Utara',
                            YOGYAKARTA:'Yogyakarta'
                    ]
            ).save()

//            new City(
//                    code: "AC01",
//                    label: "SABANG",
//                    parent: "ACEH"
//            ).save()
        }

    }

    def initProfileItems(){

        if (ProfileItem.all.empty) {
            new ProfileItem(
                    code: 'PI_ADDR001',
                    label: 'Address',
                    type: ProfileItem.TYPES.STRING,
                    seq: 1,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_OCCUPATION001',
                    label: 'Occupation',
                    type: ProfileItem.TYPES.STRING,
                    seq: 2,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_COUNTRY001',
                    label: 'Country',
                    type: ProfileItem.TYPES.LOOKUP,
                    seq: 3,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            ProfileItem dob = ProfileItem.findByCode('PI_DOB001') ?: new ProfileItem(
                    code: 'PI_DOB001',
                    label: 'Date of Birth',
                    type: ProfileItem.TYPES.DATE,
                    seq: 4,
                    role: ProfileItem.ROLES.RESPONDENT
            )
            dob.save()

            new ProfileItem(
                    code: 'PI_HEIGHT001',
                    label: 'Height',
                    type: ProfileItem.TYPES.NUMBER,
                    seq: 5,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_WEIGHT001',
                    label: 'Weight',
                    type: ProfileItem.TYPES.NUMBER,
                    seq: 6,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_EDU001',
                    label: 'Education',
                    type: ProfileItem.TYPES.LOOKUP,
                    seq: 7,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_HOBBY001',
                    label: 'Hobby',
                    type: ProfileItem.TYPES.CHOICE,
                    seq: 8,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_GENDER001',
                    label: 'Gender',
                    type: ProfileItem.TYPES.LOOKUP,
                    seq: 9,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_RELIGION001',
                    label: 'Religion',
                    type: ProfileItem.TYPES.LOOKUP,
                    seq: 10,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_INCOME001',
                    label: 'Income',
                    type: ProfileItem.TYPES.NUMBER,
                    seq: 11,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_EMP_STATUS001',
                    label: 'Employment Status',
                    type: ProfileItem.TYPES.LOOKUP,
                    seq: 12,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_CAREER001',
                    label: 'Career',
                    type: ProfileItem.TYPES.LOOKUP,
                    seq: 13,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_RELATIONSHIP001',
                    label: 'Relationship Status',
                    type: ProfileItem.TYPES.LOOKUP,
                    seq: 14,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_PARENTAL_STATUS001',
                    label: 'Parental Status',
                    type: ProfileItem.TYPES.LOOKUP,
                    seq: 15,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_PROVINCE001',
                    label: 'Province',
                    type: ProfileItem.TYPES.LOOKUP,
                    seq: 16,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()

            new ProfileItem(
                    code: 'PI_CITY001',
                    label: 'City',
                    type: ProfileItem.TYPES.LOOKUP,
                    seq: 17,
                    role: ProfileItem.ROLES.RESPONDENT
            ).save()
        }
    }

    def complementProfileItems() {
        ProfileItem address = ProfileItem.findByCode('PI_ADDR001')
        address['row'] = 3
        address['max'] = 150
        address['placeHolder'] = 'Address'
        address.save()

        ProfileItem occupation = ProfileItem.findByCode('PI_OCCUPATION001')
        occupation['max'] = 30
        occupation['placeHolder'] = 'Occupation'
        occupation.save()

        ProfileItem country = ProfileItem.findByCode('PI_COUNTRY001')
        country['lookupFrom'] = 'LM_COUNTRIES001'
        country['componentType'] = ProfileItem.COMPONENT_TYPES.SELECT
        country.save()

        ProfileItem height = ProfileItem.findByCode('PI_HEIGHT001')
        height['unit'] = 'cm'
        height['min'] = 5
        height['max'] = 1000
        height.save()

        ProfileItem weight = ProfileItem.findByCode('PI_WEIGHT001')
        weight['unit'] = 'Kg'
        weight['min'] = 10
        weight['max'] = 500
        weight.save()

        ProfileItem education = ProfileItem.findByCode('PI_EDU001')
        education['lookupFrom'] = 'LM_EDU001'
        education['componentType'] = ProfileItem.COMPONENT_TYPES.SELECT
        education.save()

        ProfileItem hobby = ProfileItem.findByCode('PI_HOBBY001')
        hobby['items'] = [
                'Sport',
                'Photography',
                'Game',
                'Programming',
                'Etc.'
        ]
        hobby['componentType'] = ProfileItem.COMPONENT_TYPES.CHK_BOX
        hobby.save()

        ProfileItem gender = ProfileItem.findByCode('PI_GENDER001')
        gender['lookupFrom'] = 'LM_GENDER001'
        gender['componentType'] = ProfileItem.COMPONENT_TYPES.RADIO
        gender.save()

        ProfileItem religion = ProfileItem.findByCode('PI_RELIGION001')
        religion['lookupFrom'] = 'LM_RELIGION001'
        religion['componentType'] = ProfileItem.COMPONENT_TYPES.SELECT
        religion.save()

        ProfileItem income = ProfileItem.findByCode('PI_INCOME001')
        income['unit'] = 'Rp'
        income['min'] = 0
        income['max'] = 9999999999
        income.save()

        ProfileItem employmentStatus = ProfileItem.findByCode('PI_EMP_STATUS001')
        employmentStatus['lookupFrom'] = 'LM_EMP_STATUS001'
        employmentStatus['componentType'] = ProfileItem.COMPONENT_TYPES.SELECT
        employmentStatus.save()

        ProfileItem career = ProfileItem.findByCode('PI_CAREER001')
        career['lookupFrom'] = 'LM_CAREER001'
        career['componentType'] = ProfileItem.COMPONENT_TYPES.SELECT
        career.save()

        ProfileItem relationship = ProfileItem.findByCode('PI_RELATIONSHIP001')
        relationship['lookupFrom'] = 'LM_RELATIONSHIP001'
        relationship['componentType'] = ProfileItem.COMPONENT_TYPES.SELECT
        relationship.save()

        ProfileItem parentalStatus = ProfileItem.findByCode('PI_PARENTAL_STATUS001')
        parentalStatus['lookupFrom'] = 'LM_PARENTAL_STATUS001'
        parentalStatus['componentType'] = ProfileItem.COMPONENT_TYPES.SELECT
        parentalStatus.save()

        ProfileItem province = ProfileItem.findByCode('PI_PROVINCE001')
        province['lookupFrom'] = 'LM_PROVINCE001'
        province['componentType'] = ProfileItem.COMPONENT_TYPES.CHK_BOX
        province.save()

        ProfileItem city = ProfileItem.findByCode('PI_CITY001')
        city['lookupFrom'] = 'LM_CITY001'
        city['componentType'] = ProfileItem.COMPONENT_TYPES.CHK_BOX
        city.save()
    }
}
