import re
from datetime import datetime
from dateutil import relativedelta
from math import ceil


class Validate:
    """Validates the data for various business use cases implemented here"""

    # Constant value to be used for the age calculation. In the format 'YYYY-MM-DD'
    CONST_DATE_FORMAT = '%Y-%m-%d'
    CONST_AGE_CUTOFF_DATE = datetime.strptime('2022-01-01', CONST_DATE_FORMAT)
    CONST_MIN_AGE = 18
    CONST_MOBILE_DIGITS = 8
    CONST_EMAIL_DOMAINS = ['com','net']

    def __init__(self, min_age=CONST_MIN_AGE, age_cutoff_date= CONST_AGE_CUTOFF_DATE,
                 mobile_digits=CONST_MOBILE_DIGITS, email_domains=CONST_EMAIL_DOMAINS):
        """
        constructor of the validate class with optional parameters
        :param no_digits: no of digits in mobile
        :param mobile: mobile# to be validated
        :return: boolean value
        """
        self.min_age = min_age
        self.mobile_pattern = re.compile(f'^\d{{{mobile_digits}}}$')
        domains = "|".join(email_domains)
        self.email_pattern = re.compile(f'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.({domains})$')
        self.age_cutoff_date = age_cutoff_date

    def validate_mobile(self, mobile: str = '') -> bool:
        """
        Validates the mobiles# and return either true or false
        :param mobile: mobile# to be validated
        :return: boolean value
        """
        return self.mobile_pattern.fullmatch(mobile) is not None

    def validate_email(self, email: str = '') -> bool:
        """
        Validates the email and return either true if it is in the expected format, otherwise false
        :param email: mobile# to be validated
        :return: boolean value
        """
        return self.email_pattern.match(email) is not None

    def check_age(self, dob: str = '') -> bool:
        """
        Check the age and return true if it is greater than minimum required age, otherwise false
        :param dob: date of birth
        :return: boolean value
        """
        return relativedelta.relativedelta(
            datetime.date(self.age_cutoff_date) , datetime.date(datetime.strptime(dob, Validate.CONST_DATE_FORMAT))).years >= self.min_age

