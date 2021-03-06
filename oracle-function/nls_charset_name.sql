create or replace function pg_catalog.NLS_CHARSET_NAME(INT)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE NOT FENCED NOT SHIPPABLE
as $$
select ('{
"1":"US7ASCII","2":"WE8DEC","3":"WE8HP","4":"US8PC437","5":"WE8EBCDIC37",
"6":"WE8EBCDIC500","7":"WE8EBCDIC1140","8":"WE8EBCDIC285","9":"WE8EBCDIC1146","10":"WE8PC850",
"11":"D7DEC","12":"F7DEC","13":"S7DEC","14":"E7DEC","15":"SF7ASCII",
"16":"NDK7DEC","17":"I7DEC","18":"NL7DEC","19":"CH7DEC","20":"YUG7ASCII",
"21":"SF7DEC","22":"TR7DEC","23":"IW7IS960","25":"IN8ISCII","27":"WE8EBCDIC1148",
"28":"WE8PC858","31":"WE8ISO8859P1","32":"EE8ISO8859P2","33":"SE8ISO8859P3","34":"NEE8ISO8859P4",
"35":"CL8ISO8859P5","36":"AR8ISO8859P6","37":"EL8ISO8859P7","38":"IW8ISO8859P8","39":"WE8ISO8859P9",
"40":"NE8ISO8859P10","41":"TH8TISASCII","42":"TH8TISEBCDIC","43":"BN8BSCII","44":"VN8VN3",
"45":"VN8MSWIN1258","46":"WE8ISO8859P15","47":"BLT8ISO8859P13","48":"CEL8ISO8859P14","49":"CL8ISOIR111",
"50":"WE8NEXTSTEP","51":"CL8KOI8U","52":"AZ8ISO8859P9E","61":"AR8ASMO708PLUS","70":"AR8EBCDICX",
"72":"AR8XBASIC","81":"EL8DEC","82":"TR8DEC","90":"WE8EBCDIC37C","91":"WE8EBCDIC500C",
"92":"IW8EBCDIC424","93":"TR8EBCDIC1026","94":"WE8EBCDIC871","95":"WE8EBCDIC284","96":"WE8EBCDIC1047",
"97":"WE8EBCDIC1140C","98":"WE8EBCDIC1145","99":"WE8EBCDIC1148C","100":"WE8EBCDIC1047E","101":"WE8EBCDIC924",
"110":"EEC8EUROASCI","113":"EEC8EUROPA3","114":"LA8PASSPORT","140":"BG8PC437S","150":"EE8PC852",
"152":"RU8PC866","153":"RU8BESTA","154":"IW8PC1507","155":"RU8PC855","156":"TR8PC857",
"158":"CL8MACCYRILLIC","159":"CL8MACCYRILLICS","160":"WE8PC860","161":"IS8PC861","162":"EE8MACCES",
"163":"EE8MACCROATIANS","164":"TR8MACTURKISHS","165":"IS8MACICELANDICS","166":"EL8MACGREEKS","167":"IW8MACHEBREWS",
"170":"EE8MSWIN1250","171":"CL8MSWIN1251","172":"ET8MSWIN923","173":"BG8MSWIN","174":"EL8MSWIN1253",
"175":"IW8MSWIN1255","176":"LT8MSWIN921","177":"TR8MSWIN1254","178":"WE8MSWIN1252","179":"BLT8MSWIN1257",
"180":"D8EBCDIC273","181":"I8EBCDIC280","182":"DK8EBCDIC277","183":"S8EBCDIC278","184":"EE8EBCDIC870",
"185":"CL8EBCDIC1025","186":"F8EBCDIC297","187":"IW8EBCDIC1086","188":"CL8EBCDIC1025X","189":"D8EBCDIC1141",
"190":"N8PC865","191":"BLT8CP921","192":"LV8PC1117","193":"LV8PC8LR","194":"BLT8EBCDIC1112",
"195":"LV8RST104090","196":"CL8KOI8R","197":"BLT8PC775","198":"DK8EBCDIC1142","199":"S8EBCDIC1143",
"200":"I8EBCDIC1144","201":"F7SIEMENS9780X","202":"E7SIEMENS9780X","203":"S7SIEMENS9780X","204":"DK7SIEMENS9780X",
"205":"N7SIEMENS9780X","206":"I7SIEMENS9780X","207":"D7SIEMENS9780X","208":"F8EBCDIC1147","210":"WE8GCOS7",
"211":"EL8GCOS7","221":"US8BS2000","222":"D8BS2000","223":"F8BS2000","224":"E8BS2000",
"225":"DK8BS2000","226":"S8BS2000","230":"WE8BS2000E","231":"WE8BS2000","232":"EE8BS2000",
"233":"CE8BS2000","235":"CL8BS2000","239":"WE8BS2000L5","241":"WE8DG","251":"WE8NCR4970",
"261":"WE8ROMAN8","262":"EE8MACCE","263":"EE8MACCROATIAN","264":"TR8MACTURKISH","265":"IS8MACICELANDIC",
"266":"EL8MACGREEK","267":"IW8MACHEBREW","277":"US8ICL","278":"WE8ICL","279":"WE8ISOICLUK",
"301":"EE8EBCDIC870C","311":"EL8EBCDIC875S","312":"TR8EBCDIC1026S","314":"BLT8EBCDIC1112S","315":"IW8EBCDIC424S",
"316":"EE8EBCDIC870S","317":"CL8EBCDIC1025S","319":"TH8TISEBCDICS","320":"AR8EBCDIC420S","322":"CL8EBCDIC1025C",
"323":"CL8EBCDIC1025R","324":"EL8EBCDIC875R","325":"CL8EBCDIC1158","326":"CL8EBCDIC1158R","327":"EL8EBCDIC423R",
"351":"WE8MACROMAN8","352":"WE8MACROMAN8S","353":"TH8MACTHAI","354":"TH8MACTHAIS","368":"HU8CWI2",
"380":"EL8PC437S","381":"EL8EBCDIC875","382":"EL8PC737","383":"LT8PC772","384":"LT8PC774",
"385":"EL8PC869","386":"EL8PC851","390":"CDN8PC863","401":"HU8ABMOD","500":"AR8ASMO8X",
"504":"AR8NAFITHA711T","505":"AR8SAKHR707T","506":"AR8MUSSAD768T","507":"AR8ADOS710T","508":"AR8ADOS720T",
"509":"AR8APTEC715T","511":"AR8NAFITHA721T","514":"AR8HPARABIC8T","554":"AR8NAFITHA711","555":"AR8SAKHR707",
"556":"AR8MUSSAD768","557":"AR8ADOS710","558":"AR8ADOS720","559":"AR8APTEC715","560":"AR8MSWIN1256",
"561":"AR8NAFITHA721","563":"AR8SAKHR706","565":"AR8ARABICMAC","566":"AR8ARABICMACS","567":"AR8ARABICMACT",
"590":"LA8ISO6937","798":"WE8DECTST","829":"JA16VMS","830":"JA16EUC","831":"JA16EUCYEN",
"832":"JA16SJIS","833":"JA16DBCS","834":"JA16SJISYEN","835":"JA16EBCDIC930","836":"JA16MACSJIS",
"837":"JA16EUCTILDE","838":"JA16SJISTILDE","840":"KO16KSC5601","842":"KO16DBCS","845":"KO16KSCCS",
"846":"KO16MSWIN949","850":"ZHS16CGB231280","851":"ZHS16MACCGB231280","852":"ZHS16GBK","853":"ZHS16DBCS",
"854":"ZHS32GB18030","860":"ZHT32EUC","861":"ZHT32SOPS","862":"ZHT16DBT","863":"ZHT32TRIS",
"864":"ZHT16DBCS","865":"ZHT16BIG5","866":"ZHT16CCDC","867":"ZHT16MSWIN950","868":"ZHT16HKSCS",
"870":"AL24UTFFSS","871":"UTF8","872":"UTFE","873":"AL32UTF8","992":"ZHT16HKSCS31",
"993":"ZHT32EUCTST","994":"WE16DECTST2","995":"WE16DECTST","996":"KO16TSTSET","997":"JA16TSTSET2",
"998":"JA16TSTSET","1000":"UTF16","1001":"US16TSTFIXED","1002":"TIMESTEN8","1830":"JA16EUCFIXED",
"1832":"JA16SJISFIXED","1833":"JA16DBCSFIXED","1840":"KO16KSC5601FIXED","1842":"KO16DBCSFIXED","1850":"ZHS16CGB231280FIXED",
"1852":"ZHS16GBKFIXED","1853":"ZHS16DBCSFIXED","1860":"ZHT32EUCFIXED","1863":"ZHT32TRISFIXED","1864":"ZHT16DBCSFIXED",
"1865":"ZHT16BIG5FIXED","2000":"AL16UTF16","2002":"AL16UTF16LE"
}'::json->>$1::TEXT)::text;
$$;
/

--SELECT NLS_CHARSET_NAME(873);