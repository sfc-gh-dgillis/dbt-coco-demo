import unittest
from cmd.pysrc.concatenate_dict_values import concatenate_dict_values


class TestConcatenateDictValues(unittest.TestCase):
    def test_basic(self):
        d = {'b': '2', 'a': '1', 'c': '3'}
        self.assertEqual(concatenate_dict_values(d), '1-2-3')

    def test_with_nulls(self):
        d = {'a': None, 'b': '', 'c': []}
        expected = '_SURROGATE_KEY_NULL_-_SURROGATE_KEY_NULL_-_SURROGATE_KEY_NULL_'
        self.assertEqual(expected, concatenate_dict_values(d))

    def test_mixed(self):
        d = {'a': 'foo', 'b': '', 'c': 0}
        expected = 'FOO-_SURROGATE_KEY_NULL_-0'
        self.assertEqual(expected, concatenate_dict_values(d) )

    def test_custom_null(self):
        d = {'a': None, 'b': 'bar'}
        self.assertEqual( 'NULL-BAR',concatenate_dict_values(d, default_null_value='NULL'))


    def test_sorting(self):
        d = {'a': None, 'b': 'bar'}
        self.assertEqual('NULL-BAR',concatenate_dict_values(d, default_null_value='NULL') )

    def test_case_sensitivity(self):
        d = {'a': 'foo', 'b': 'Bar', 'c': 'bAz'}
        expected = 'FOO-BAR-BAZ'
        self.assertEqual(concatenate_dict_values(d), expected)

    def test_case_sensitivity_with_null(self):
        d = {'a': 'foo', 'b': None, 'c': 'bAz'}
        expected = 'FOO-_SURROGATE_KEY_NULL_-BAZ'
        self.assertEqual(concatenate_dict_values(d), expected)


if __name__ == '__main__':
    unittest.main()