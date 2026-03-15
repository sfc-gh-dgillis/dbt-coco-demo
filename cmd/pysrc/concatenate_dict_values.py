def concatenate_dict_values(input_dict, default_null_value="_SURROGATE_KEY_NULL_"):
    """
    Concatenate the values of a dict in key order, replacing empty values with a default, separated by '-'.
    All values are uppercased.
    Args:
        input_dict (dict): The dictionary whose values to concatenate.
        default_null_value (str): The value to use if a dict value is empty.
    Returns:
        str: Concatenated string of values in key order, separated by '-'
    """
    return '-'.join([
        str(input_dict[k]).upper() if input_dict[k] not in (None, '', []) else default_null_value.upper()
        for k in sorted(input_dict.keys())
    ])
