## iOS 에서 한글 EUC-KR Encoding 문제

### why

어제 네이버의 iOS 개발 사이트에 아래와 같은 질문이 걸렸습니다
	
> data를 string 변환이 안되네요.
>
> 서버로 부터 전달된 데이타의 encoding 은 EUC-KR 이라고 하며 Encoding 시  0x0940 으로 했다고 합니다.


저와 같은 경우 이전에 Encoding 시 0x0422 로 했는데... 라고 생각하며 좀 검색을 해봤습니다.


### how

[Apple 에 정의된 Encoding](https://github.com/apple/swift-corelibs-foundation/blob/master/CoreFoundation/String.subproj/CFStringEncodingExt.h) 관련된 header 파일에는 아래와 같이 선언되어 있습니다.


1. EUC-KR 관련 define

	~~~swift
   /* EUC collections begin at 0x900 */
    kCFStringEncodingEUC_JP = 0x0920,		/* ISO 646, 1-byte katakana, JIS 208, JIS 212 */
    kCFStringEncodingEUC_CN = 0x0930,		/* ISO 646, GB 2312-80 */
    kCFStringEncodingEUC_TW = 0x0931,		/* ISO 646, CNS 11643-1992 Planes 1-16 */
    kCFStringEncodingEUC_KR = 0x0940,		/* ISO 646, KS C 5601-1987 */
	~~~
	
2.  MS-DOS & Windows encodings define

	~~~swift
	/* MS-DOS & Windows encodings begin at 0x400 */
    kCFStringEncodingDOSLatinUS = 0x0400,	/* code page 437 */
    kCFStringEncodingDOSGreek = 0x0405,		/* code page 737 (formerly code page 437G) */
    kCFStringEncodingDOSBalticRim = 0x0406,	/* code page 775 */
    kCFStringEncodingDOSLatin1 = 0x0410,	/* code page 850, "Multilingual" */
    kCFStringEncodingDOSGreek1 = 0x0411,	/* code page 851 */
    kCFStringEncodingDOSLatin2 = 0x0412,	/* code page 852, Slavic */
    kCFStringEncodingDOSCyrillic = 0x0413,	/* code page 855, IBM Cyrillic */
    kCFStringEncodingDOSTurkish = 0x0414,	/* code page 857, IBM Turkish */
    kCFStringEncodingDOSPortuguese = 0x0415,	/* code page 860 */
    kCFStringEncodingDOSIcelandic = 0x0416,	/* code page 861 */
    kCFStringEncodingDOSHebrew = 0x0417,	/* code page 862 */
    kCFStringEncodingDOSCanadianFrench = 0x0418, /* code page 863 */
    kCFStringEncodingDOSArabic = 0x0419,	/* code page 864 */
    kCFStringEncodingDOSNordic = 0x041A,	/* code page 865 */
    kCFStringEncodingDOSRussian = 0x041B,	/* code page 866 */
    kCFStringEncodingDOSGreek2 = 0x041C,	/* code page 869, IBM Modern Greek */
    kCFStringEncodingDOSThai = 0x041D,		/* code page 874, also for Windows */
    kCFStringEncodingDOSJapanese = 0x0420,	/* code page 932, also for Windows */
    kCFStringEncodingDOSChineseSimplif = 0x0421, /* code page 936, also for Windows */
    kCFStringEncodingDOSKorean = 0x0422,	/* code page 949, also for Windows; Unified Hangul Code */
    kCFStringEncodingDOSChineseTrad = 0x0423,	/* code page 950, also for Windows */
/*  kCFStringEncodingWindowsLatin1 = 0x0500, defined in CoreFoundation/CFString.h */
    kCFStringEncodingWindowsLatin2 = 0x0501,	/* code page 1250, Central Europe */
    kCFStringEncodingWindowsCyrillic = 0x0502,	/* code page 1251, Slavic Cyrillic */
    kCFStringEncodingWindowsGreek = 0x0503,	/* code page 1253 */
    kCFStringEncodingWindowsLatin5 = 0x0504,	/* code page 1254, Turkish */
    kCFStringEncodingWindowsHebrew = 0x0505,	/* code page 1255 */
    kCFStringEncodingWindowsArabic = 0x0506,	/* code page 1256 */
    kCFStringEncodingWindowsBalticRim = 0x0507,	/* code page 1257 */
    kCFStringEncodingWindowsVietnamese = 0x0508, /* code page 1258 */
    kCFStringEncodingWindowsKoreanJohab = 0x0510, /* code page 1361, for Windows NT */
	~~~

3. 위에 질문을 하신분이 윈도우 서버에서 EUC-KR 로 encoding 된 데이타에 한글이 포함되어 있다면... 아마도 완성형 한글일것 같네요. 
따라서 아래와 같이 Encoding 시 0x0422 에 해당하는 kCFStringEncodingDOSKorean 이 맞지 않을까 싶네요.

	~~~swift
	
	let content = "가수 비(정지훈)와 배우 김태희가 동료 스타들의 축복 속 부부의 연을 맺었다.\n\n비와 김태희는 19일 오후 2시 서울 종로구 가회동 성당에서 혼배미사를 올리고 부부로 첫 걸음을 내딛었다. 지난 2011년 처음 만나 연인으로 발전한 두 사람은 이로써 열애 5년여 만에 사랑의 결실을 맺게 됐다."
	
	let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)
	
	let size = content.lengthOfBytes(using: String.Encoding(rawValue: encodingEUCKR)) + 1
	
	var buffer: [CChar] = [CChar](repeating: 0, count: size)
	
	/// UTF8 -> EUC-KR 로 변환
	let result = strData.getCString(&buffer, maxLength: size, encoding: String.Encoding(rawValue: encodingEUCKR))

	print(buffer)
	print(buffer.count)
	// output : [-80, -95, -68, ... , -39, 46, 0]
	// output : 272 byte
	
	
	/// EUC-KR -> UTF8 로 변환
	let data = Data(bytes: buffer, count: size)
	let strUTF8 = String(data: data, encoding: String.Encoding(rawValue: encodingEUCKR))
	
	print(strUTF8)

	~~~


### reference

* [Apple 에 정의된 encoding](https://github.com/apple/swift-corelibs-foundation/blob/master/CoreFoundation/String.subproj/CFStringEncodingExt.h)