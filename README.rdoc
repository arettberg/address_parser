AddressParser - by Allen Rettberg

This program parses a block-text address in standard USPS format:

Peter Griffin
31 Spooner St.
Quahog, RI 00093

List of possible attributes (*indicates required):

*name_1: 		Name line 1
 name_2: 		Name line 2
 name_3: 		Name line 3
 care_of: 		If the address contains a 'care of' field
*street_number: Street number - Required unless PO Box is present
*street_name: 	Street name - Required unless PO Box is present
 unit_name:		"Apt.", "Unit", "#" etc. - if 'unit' is used, # must be present ('unit #' or 'unit#')
 unit_number:	Number of above unit category
*po_box:		PO Box number - Required unless street address is present
*city:			City
*state:			State
*zip_5:			5-digit zip code
 zip-4			4-digit zip suffix

City/State/Zip must be on last line, any line beyond this line will be discarded. The only exception to this rule is that the zip code may occupy the line below city, state.

Zip code may be in 5-digit form or 9-digit form, but the 4-digit suffix must be separated by a single hyphen. If the suffix is in an incorrect format, it will be discarded.

The find_indicators method iterates through an array of hashes in the following format, in order to find keywords and patters:

{key_label: :box_name,
 value_label: :po_box,
 key_type: :string,
 value_type: :integer,
 key_regex: PO_BOX_FULL_REGEX,
 key_db_regex: PO_BOX_REGEX,
 value_regex: NUM_REGEX}

• :key_label specifies the label under which to store the indicator key (ie "apt." or "#").
	It is only required if this information must be saved for recall.
• :value_label similarly specifies where the value of the indicator should be stored in the main hash. 
	This, for example, would be the number in PO Box 1234
• :key_type specifies whether the key should be stored as an integer or string. If omitted, it defaults to string.
	This is only required if :key_label is set
• :value_type is the same as :key_type, for the value instead
• :key_regex specifies the pattern to find the indicator
• :key_db_regex this should only be set if :key_regex needs to include the indicator value in the 
	regex, but the key name must be stored separately. This specifies the regex to exclude the indicator value,
	from key_match
• :value_regex specifies the regex to extract the indicator value


:key label, :key_type, :value_type, and :key_db_regex are not strictly required.
