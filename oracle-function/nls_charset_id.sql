CREATE OR REPLACE FUNCTION pg_catalog.nls_charset_id(text)
 RETURNS integer
 LANGUAGE sql
 IMMUTABLE NOT FENCED NOT SHIPPABLE
AS $$
select ('{
"US7ASCII":1,"WE8DEC":2,"WE8HP":3,"US8PC437":4,"WE8EBCDIC37":5,
"WE8EBCDIC500":6,"WE8EBCDIC1140":7,"WE8EBCDIC285":8,"WE8EBCDIC1146":9,"WE8PC850":10,
"D7DEC":11,"F7DEC":12,"S7DEC":13,"E7DEC":14,"SF7ASCII":15,
"NDK7DEC":16,"I7DEC":17,"NL7DEC":18,"CH7DEC":19,"YUG7ASCII":20,
"SF7DEC":21,"TR7DEC":22,"IW7IS960":23,"IN8ISCII":25,"WE8EBCDIC1148":27,
"WE8PC858":28,"WE8ISO8859P1":31,"EE8ISO8859P2":32,"SE8ISO8859P3":33,"NEE8ISO8859P4":34,
"CL8ISO8859P5":35,"AR8ISO8859P6":36,"EL8ISO8859P7":37,"IW8ISO8859P8":38,"WE8ISO8859P9":39,
"NE8ISO8859P10":40,"TH8TISASCII":41,"TH8TISEBCDIC":42,"BN8BSCII":43,"VN8VN3":44,
"VN8MSWIN1258":45,"WE8ISO8859P15":46,"BLT8ISO8859P13":47,"CEL8ISO8859P14":48,"CL8ISOIR111":49,
"WE8NEXTSTEP":50,"CL8KOI8U":51,"AZ8ISO8859P9E":52,"AR8ASMO708PLUS":61,"AR8EBCDICX":70,
"AR8XBASIC":72,"EL8DEC":81,"TR8DEC":82,"WE8EBCDIC37C":90,"WE8EBCDIC500C":91,
"IW8EBCDIC424":92,"TR8EBCDIC1026":93,"WE8EBCDIC871":94,"WE8EBCDIC284":95,"WE8EBCDIC1047":96,
"WE8EBCDIC1140C":97,"WE8EBCDIC1145":98,"WE8EBCDIC1148C":99,"WE8EBCDIC1047E":100,"WE8EBCDIC924":101,
"EEC8EUROASCI":110,"EEC8EUROPA3":113,"LA8PASSPORT":114,"BG8PC437S":140,"EE8PC852":150,
"RU8PC866":152,"RU8BESTA":153,"IW8PC1507":154,"RU8PC855":155,"TR8PC857":156,
"CL8MACCYRILLIC":158,"CL8MACCYRILLICS":159,"WE8PC860":160,"IS8PC861":161,"EE8MACCES":162,
"EE8MACCROATIANS":163,"TR8MACTURKISHS":164,"IS8MACICELANDICS":165,"EL8MACGREEKS":166,"IW8MACHEBREWS":167,
"EE8MSWIN1250":170,"CL8MSWIN1251":171,"ET8MSWIN923":172,"BG8MSWIN":173,"EL8MSWIN1253":174,
"IW8MSWIN1255":175,"LT8MSWIN921":176,"TR8MSWIN1254":177,"WE8MSWIN1252":178,"BLT8MSWIN1257":179,
"D8EBCDIC273":180,"I8EBCDIC280":181,"DK8EBCDIC277":182,"S8EBCDIC278":183,"EE8EBCDIC870":184,
"CL8EBCDIC1025":185,"F8EBCDIC297":186,"IW8EBCDIC1086":187,"CL8EBCDIC1025X":188,"D8EBCDIC1141":189,
"N8PC865":190,"BLT8CP921":191,"LV8PC1117":192,"LV8PC8LR":193,"BLT8EBCDIC1112":194,
"LV8RST104090":195,"CL8KOI8R":196,"BLT8PC775":197,"DK8EBCDIC1142":198,"S8EBCDIC1143":199,
"I8EBCDIC1144":200,"F7SIEMENS9780X":201,"E7SIEMENS9780X":202,"S7SIEMENS9780X":203,"DK7SIEMENS9780X":204,
"N7SIEMENS9780X":205,"I7SIEMENS9780X":206,"D7SIEMENS9780X":207,"F8EBCDIC1147":208,"WE8GCOS7":210,
"EL8GCOS7":211,"US8BS2000":221,"D8BS2000":222,"F8BS2000":223,"E8BS2000":224,
"DK8BS2000":225,"S8BS2000":226,"WE8BS2000E":230,"WE8BS2000":231,"EE8BS2000":232,
"CE8BS2000":233,"CL8BS2000":235,"WE8BS2000L5":239,"WE8DG":241,"WE8NCR4970":251,
"WE8ROMAN8":261,"EE8MACCE":262,"EE8MACCROATIAN":263,"TR8MACTURKISH":264,"IS8MACICELANDIC":265,
"EL8MACGREEK":266,"IW8MACHEBREW":267,"US8ICL":277,"WE8ICL":278,"WE8ISOICLUK":279,
"EE8EBCDIC870C":301,"EL8EBCDIC875S":311,"TR8EBCDIC1026S":312,"BLT8EBCDIC1112S":314,"IW8EBCDIC424S":315,
"EE8EBCDIC870S":316,"CL8EBCDIC1025S":317,"TH8TISEBCDICS":319,"AR8EBCDIC420S":320,"CL8EBCDIC1025C":322,
"CL8EBCDIC1025R":323,"EL8EBCDIC875R":324,"CL8EBCDIC1158":325,"CL8EBCDIC1158R":326,"EL8EBCDIC423R":327,
"WE8MACROMAN8":351,"WE8MACROMAN8S":352,"TH8MACTHAI":353,"TH8MACTHAIS":354,"HU8CWI2":368,
"EL8PC437S":380,"EL8EBCDIC875":381,"EL8PC737":382,"LT8PC772":383,"LT8PC774":384,
"EL8PC869":385,"EL8PC851":386,"CDN8PC863":390,"HU8ABMOD":401,"AR8ASMO8X":500,
"AR8NAFITHA711T":504,"AR8SAKHR707T":505,"AR8MUSSAD768T":506,"AR8ADOS710T":507,"AR8ADOS720T":508,
"AR8APTEC715T":509,"AR8NAFITHA721T":511,"AR8HPARABIC8T":514,"AR8NAFITHA711":554,"AR8SAKHR707":555,
"AR8MUSSAD768":556,"AR8ADOS710":557,"AR8ADOS720":558,"AR8APTEC715":559,"AR8MSWIN1256":560,
"AR8NAFITHA721":561,"AR8SAKHR706":563,"AR8ARABICMAC":565,"AR8ARABICMACS":566,"AR8ARABICMACT":567,
"LA8ISO6937":590,"WE8DECTST":798,"JA16VMS":829,"JA16EUC":830,"JA16EUCYEN":831,
"JA16SJIS":832,"JA16DBCS":833,"JA16SJISYEN":834,"JA16EBCDIC930":835,"JA16MACSJIS":836,
"JA16EUCTILDE":837,"JA16SJISTILDE":838,"KO16KSC5601":840,"KO16DBCS":842,"KO16KSCCS":845,
"KO16MSWIN949":846,"ZHS16CGB231280":850,"ZHS16MACCGB231280":851,"ZHS16GBK":852,"ZHS16DBCS":853,
"ZHS32GB18030":854,"ZHT32EUC":860,"ZHT32SOPS":861,"ZHT16DBT":862,"ZHT32TRIS":863,
"ZHT16DBCS":864,"ZHT16BIG5":865,"ZHT16CCDC":866,"ZHT16MSWIN950":867,"ZHT16HKSCS":868,
"AL24UTFFSS":870,"UTF8":871,"UTFE":872,"AL32UTF8":873,"ZHT16HKSCS31":992,
"ZHT32EUCTST":993,"WE16DECTST2":994,"WE16DECTST":995,"KO16TSTSET":996,"JA16TSTSET2":997,
"JA16TSTSET":998,"UTF16":1000,"US16TSTFIXED":1001,"TIMESTEN8":1002,"JA16EUCFIXED":1830,
"JA16SJISFIXED":1832,"JA16DBCSFIXED":1833,"KO16KSC5601FIXED":1840,"KO16DBCSFIXED":1842,"ZHS16CGB231280FIXED":1850,
"ZHS16GBKFIXED":1852,"ZHS16DBCSFIXED":1853,"ZHT32EUCFIXED":1860,"ZHT32TRISFIXED":1863,"ZHT16DBCSFIXED":1864,
"ZHT16BIG5FIXED":1865,"AL16UTF16":2000,"AL16UTF16LE":2002
}'::json->>$1)::int;
$$;
/

--SELECT nls_charset_id('AL32UTF8')