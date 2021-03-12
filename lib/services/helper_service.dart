class HelperService {
  static bool validateData(name, email, address, password, confirmPassword) {
    if (name == null || name.length == 0) {
      throw 'ERROR_NAME_FIELD_EMPTY';
    } else if (email == null || email.length == 0) {
      throw 'ERROR_EMAIL_FIELD_EMPTY';
    } else if (password == null || password.length == 0) {
      throw 'ERROR_PASSWORD_FIELD_EMPTY';
    } else if (confirmPassword == null || confirmPassword.length == 0) {
      throw 'ERROR_CONFIRM_PASSWORD_FIELD_EMPTY';
    } else if (address == null || address.length == 0) {
      throw 'ERROR_ADDRESS_FIELD_EMPTY';
    } else if (password != confirmPassword) {
      throw 'ERROR_PASSWORD_MISSMATCH';
    }

    bool emailValid =
        RegExp(r'\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b')
            .hasMatch(email);
    if (!emailValid) {
      throw 'ERROR_INVALID_EMAIL';
    }

    return true;
  }

  static String getFirstName(fullName) {
    String firstName = fullName.split(' ')[0];
    return firstName[0].toUpperCase() + firstName.substring(1).toLowerCase();
  }

  static String convertDateTimeToHumanReadable(DateTime givenTime) {
    //Convert the DateTime to human readable format(dd/mm/yyyy  HH:MM AM/PM).
    String day, month, year, time, date;
    year = givenTime.toString().substring(0, 4);
    month = givenTime.toString().substring(5, 7);
    day = givenTime.toString().substring(8, 10);
    date = day + '/' + month + '/' + year;
    time = (givenTime.hour == 0 || givenTime.hour == 12
                ? 12
                : givenTime.hour.toInt() % 12)
            .toString() +
        ':' +
        (givenTime.minute.toInt() % 60).toString().padLeft(2, '0') +
        (givenTime.hour > 12 ? ' PM' : ' AM');
    return date + '  ' + time;
  }
}
