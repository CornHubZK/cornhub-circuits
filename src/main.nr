/**
* The following circuit is a simplified version of Ocelots' circuits
* available here: https://github.com/ocelots-app/passport-verifier
* The date library is identical to this one: https://github.com/madztheo/noir-date
* except that the compiler_version is set to 0.19.0 instead of 0.22.0
*/

use dep::date::Date;

// Index for the date of birth (YYMMDD)
global MRZ_BIRTHDATE_INDEX = 57;

fn get_array_slice<N, M>(arr: [u8; N], start: u32, end: u32) -> [u8; M] {
    let mut slice = [0 as u8; M];
    for i in start..end {
        slice[i - start] = arr[i];
    }
    slice
}

fn proof_of_age(
    mrz: [u8; 88],
    age_required: u8,
    is_limit_minimum: bool,
    current_date_bytes: [u8; 8]
) {
    // Get the slice of the MRZ representing the birthdate
    let birthdate_bytes = get_array_slice(mrz, MRZ_BIRTHDATE_INDEX, MRZ_BIRTHDATE_INDEX + 6);

    // Create a Date object from the birthdate using the current date as
    // the pivot year to differentiate between 20th and 21st centuries
    // as the format is "YYMMDD"
    let birthdate = Date::from_bytes_short_year(
        birthdate_bytes,
        [current_date_bytes[2], current_date_bytes[3]]
    );

    // Create a Date object from the current date using the "YYYYMMDD" format
    let current_date = Date::from_bytes_long_year(current_date_bytes);

    // Check if the age of the passport holder is match the required age
    // It can be either the minimum age required or the maximum age required
    if is_limit_minimum {
        assert(current_date.gte(birthdate.add_years(age_required as u32)));
    } else {
        assert(current_date.lte(birthdate.add_years(age_required as u32)));
    }
}

fn main(
    mrz: [u8; 88],
    // The current date is public so verifiers can check the date
    // provided to the proof is correct
    current_date: pub [u8; 8],
    // The minimum age required is public so verifiers can check
    // the age provided to the proof is correct
    min_age_required: pub u8,
) {
    // Verify the age of the passport holder
    proof_of_age(mrz, min_age_required, true, current_date);
}
