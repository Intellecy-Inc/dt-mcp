/*
 * DEVONthink.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class DEVONthinkApplication, DEVONthinkWindow, DEVONthinkRichText, DEVONthinkAttachment, DEVONthinkAttributeRun, DEVONthinkCharacter, DEVONthinkParagraph, DEVONthinkWord, DEVONthinkApplication, DEVONthinkDatabase, DEVONthinkRecord, DEVONthinkChild, DEVONthinkContent, DEVONthinkIncomingReference, DEVONthinkIncomingWikiReference, DEVONthinkOutgoingReference, DEVONthinkOutgoingWikiReference, DEVONthinkParent, DEVONthinkReminder, DEVONthinkSelectedRecord, DEVONthinkSmartParent, DEVONthinkTagGroup, DEVONthinkTab, DEVONthinkThinkWindow, DEVONthinkDocumentWindow, DEVONthinkMainWindow;

enum DEVONthinkSaveOptions {
	DEVONthinkSaveOptionsYes = 'yes ' /* Save the file. */,
	DEVONthinkSaveOptionsNo = 'no  ' /* Do not save the file. */,
	DEVONthinkSaveOptionsAsk = 'ask ' /* Ask the user whether or not to save the file. */
};
typedef enum DEVONthinkSaveOptions DEVONthinkSaveOptions;

enum DEVONthinkPrintingErrorHandling {
	DEVONthinkPrintingErrorHandlingStandard = 'lwst' /* Standard PostScript error handling */,
	DEVONthinkPrintingErrorHandlingDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum DEVONthinkPrintingErrorHandling DEVONthinkPrintingErrorHandling;

enum DEVONthinkTextAlignment {
	DEVONthinkTextAlignmentLeft = 'DAa0' /*  */,
	DEVONthinkTextAlignmentCenter = 'DAa1' /*  */,
	DEVONthinkTextAlignmentRight = 'DAa2' /*  */,
	DEVONthinkTextAlignmentJustified = 'DAa3' /*  */,
	DEVONthinkTextAlignmentNatural = 'DAa4' /*  */
};
typedef enum DEVONthinkTextAlignment DEVONthinkTextAlignment;

enum DEVONthinkChatEngine {
	DEVONthinkChatEngineAppleAI = 'APAI' /* Apple Intelligence */,
	DEVONthinkChatEngineChatGPT = 'CGPT' /* OpenAI's ChatGPT */,
	DEVONthinkChatEngineClaude = 'CLAU' /* Anthropic's Claude */,
	DEVONthinkChatEngineGemini = 'GEMI' /* Google's Gemini */,
	DEVONthinkChatEngineMistral = 'MIAI' /* Mistral's AI */,
	DEVONthinkChatEnginePerplexity = 'PRPX' /* Perplexity's AI */,
	DEVONthinkChatEngineOpenRouter = 'OPRT' /* OpenRouter AI */,
	DEVONthinkChatEngineOpenAICompatible = '4All' /* OpenAI-compatible engine */,
	DEVONthinkChatEngineLMStudio = 'LMST' /* Element Lab's LM Studio */,
	DEVONthinkChatEngineOllama = 'OLMA' /* Local Ollama installation */,
	DEVONthinkChatEngineRemoteOllama = 'OLLA' /* Remote Ollama server */
};
typedef enum DEVONthinkChatEngine DEVONthinkChatEngine;

enum DEVONthinkChatUsage {
	DEVONthinkChatUsageCheapest = 'UgU0' /* Least tokens, low reasoning & search effort and reduced vision quality */,
	DEVONthinkChatUsageAuto = 'UgU1' /* Automatic */,
	DEVONthinkChatUsageBest = 'UgU2' /* Unlimited tokens, high reasoning & search effort and highest vision quality */
};
typedef enum DEVONthinkChatUsage DEVONthinkChatUsage;

enum DEVONthinkComparisonType {
	DEVONthinkComparisonTypeDataComparison = 'ptp0' /* Uses text & metadata */,
	DEVONthinkComparisonTypeTagsComparison = 'ptp1' /* Uses tags */
};
typedef enum DEVONthinkComparisonType DEVONthinkComparisonType;

enum DEVONthinkConcordanceSorting {
	DEVONthinkConcordanceSortingWeight = 'wght' /* Sorted by weight */,
	DEVONthinkConcordanceSortingFrequency = 'freq' /* Sorted by frequency */
};
typedef enum DEVONthinkConcordanceSorting DEVONthinkConcordanceSorting;

enum DEVONthinkConvertType {
	DEVONthinkConvertTypeBookmark = 'DTnx' /* Bookmark */,
	DEVONthinkConvertTypeSimple = 'ctp1' /* Plain text */,
	DEVONthinkConvertTypeRich = 'ctp2' /* Rich text */,
	DEVONthinkConvertTypeNote = 'note' /* Formatted Note */,
	DEVONthinkConvertTypeMarkdown = 'mkdn' /* Markdown document */,
	DEVONthinkConvertTypeHTML = 'html' /* HTML document */,
	DEVONthinkConvertTypeWebarchive = 'wbar' /* Web Archive */,
	DEVONthinkConvertTypePDFDocument = 'pdf ' /* PDF document (Paginated) */,
	DEVONthinkConvertTypeSinglePagePDFDocument = 'ctp4' /* PDF document (One Page) */,
	DEVONthinkConvertTypePDFWithoutAnnotations = 'ctp3' /* PDF document without annotations */,
	DEVONthinkConvertTypePDFWithAnnotationsBurntIn = 'ctp5' /* PDF/A document with annotations burnt in */
};
typedef enum DEVONthinkConvertType DEVONthinkConvertType;

enum DEVONthinkDataType {
	DEVONthinkDataTypeGroup = 'DTgr' /* Group */,
	DEVONthinkDataTypeSmartGroup = 'DTsg' /* Smart group */,
	DEVONthinkDataTypeFeed = 'feed' /* RSS, RDF or Atom feed */,
	DEVONthinkDataTypeBookmark = 'DTnx' /* Internet or filesystem location */,
	DEVONthinkDataTypeFormattedNote = 'DTft',
	DEVONthinkDataTypeHTML = 'html' /* HTML document */,
	DEVONthinkDataTypeWebarchive = 'wbar' /* Web Archive */,
	DEVONthinkDataTypeMarkdown = 'mkdn' /* Markdown document */,
	DEVONthinkDataTypeTxt = 'txt ' /* Text document */,
	DEVONthinkDataTypeRTF = 'rtf ' /* RTF document */,
	DEVONthinkDataTypeRTFD = 'rtfd' /* RTFD document */,
	DEVONthinkDataTypePicture = 'pict' /* Picture */,
	DEVONthinkDataTypeMultimedia = 'quti' /* Audio or video file */,
	DEVONthinkDataTypePDFDocument = 'pdf ' /* PDF document */,
	DEVONthinkDataTypeSheet = 'tabl' /* Sheet */,
	DEVONthinkDataTypeXML = 'xml ' /* XML document */,
	DEVONthinkDataTypePropertyList = 'plis' /* Property list */,
	DEVONthinkDataTypeAppleScriptFile = 'apsc' /* AppleScript file */,
	DEVONthinkDataTypeEmail = 'eml ' /* Email */,
	DEVONthinkDataTypeUnknown = '****' /* Unknown file */
};
typedef enum DEVONthinkDataType DEVONthinkDataType;

enum DEVONthinkImageEngine {
	DEVONthinkImageEngineDallE2 = 'Dal2' /* OpenAI's Dall-E 2 */,
	DEVONthinkImageEngineDallE3 = 'Dal3' /* OpenAI's Dall-E 3 */,
	DEVONthinkImageEngineGPTImage1 = 'GTI1' /* OpenAI's GPT-Image-1 */,
	DEVONthinkImageEngineFluxSchnell = 'FlxS' /* Black Forest Labs' Flux Schnell */,
	DEVONthinkImageEngineFluxPro = 'FlxP' /* Black Forest Labs' Flux Pro */,
	DEVONthinkImageEngineFluxProUltra = 'FlxU' /* Black Forest Labs' Flux Pro Ultra */,
	DEVONthinkImageEngineRecraft3 = 'Rcf3' /* Recraft AI's Recraft 3 */,
	DEVONthinkImageEngineStableDiffusion = 'StDL' /* Stability AI's Stable Diffusion 3.5 Large */,
	DEVONthinkImageEngineStableDiffusionTurbo = 'StDT' /* Stability AI's Stable Diffusion 3.5 Large Turbo */,
	DEVONthinkImageEngineImagen3Fast = 'GIgF' /* Google's Imagen 3 Fast */,
	DEVONthinkImageEngineImagen3 = 'GIg3' /* Google's Imagen 3 */,
	DEVONthinkImageEngineImagen4 = 'GIg4' /* Google's Imagen 4 */,
	DEVONthinkImageEngineImagen4Fast = 'GI4F' /* Google's Imagen 4 Fast */,
	DEVONthinkImageEngineImagen4Ultra = 'GI4U' /* Google's Imagen 4 Ultra */,
	DEVONthinkImageEngineNanoBanana = 'GINB' /* Google's Nano Banana */
};
typedef enum DEVONthinkImageEngine DEVONthinkImageEngine;

enum DEVONthinkReminderAlarm {
	DEVONthinkReminderAlarmNoAlarm = 'ra00' /* No alarm. */,
	DEVONthinkReminderAlarmDock = 'ra02' /* Bounce Dock icon. */,
	DEVONthinkReminderAlarmSound = 'ra03' /* Play sound. */,
	DEVONthinkReminderAlarmSpeak = 'ra04' /* Speak text. */,
	DEVONthinkReminderAlarmNotification = 'ra05' /* Display notification. */,
	DEVONthinkReminderAlarmAlert = 'ra27' /* Display alert. */,
	DEVONthinkReminderAlarmOpenInternally = 'ra30' /* Open in DEVONthink. */,
	DEVONthinkReminderAlarmOpenExternally = 'ra25' /* Open in default application. */,
	DEVONthinkReminderAlarmLaunch = 'ra24' /* Launch URL. */,
	DEVONthinkReminderAlarmMailWithItemLink = 'ra29' /* Send mail with item link. */,
	DEVONthinkReminderAlarmMailWithAttachment = 'ra97' /* Send mail with attachment. */,
	DEVONthinkReminderAlarmAddToReadingList = 'ra26' /* Add to reading list. */,
	DEVONthinkReminderAlarmEmbeddedScript = 'ra99' /* Execute embedded script (AppleScript). */,
	DEVONthinkReminderAlarmEmbeddedJXAScript = 'ra98' /* Execute embedded script (JavaScript). */,
	DEVONthinkReminderAlarmExternalScript = 'ra06' /* Execute external script. */
};
typedef enum DEVONthinkReminderAlarm DEVONthinkReminderAlarm;

enum DEVONthinkReminderDay {
	DEVONthinkReminderDayNoDay = 'rd00' /* No day. */,
	DEVONthinkReminderDaySunday = 'rd01' /* Sunday. */,
	DEVONthinkReminderDayMonday = 'rd02' /* Monday. */,
	DEVONthinkReminderDayTuesday = 'rd03' /* Tuesday. */,
	DEVONthinkReminderDayWednesday = 'rd04' /* Wednesday. */,
	DEVONthinkReminderDayThursday = 'rd05' /* Thursday. */,
	DEVONthinkReminderDayFriday = 'rd06' /* Friday. */,
	DEVONthinkReminderDaySaturday = 'rd07' /* Saturday. */,
	DEVONthinkReminderDayAnyDay = 'rd08' /* Any day. */,
	DEVONthinkReminderDayWorkdays = 'rd09' /* Workdays. */,
	DEVONthinkReminderDayWeekend = 'rd10' /* Weekend. */
};
typedef enum DEVONthinkReminderDay DEVONthinkReminderDay;

enum DEVONthinkReminderSchedule {
	DEVONthinkReminderScheduleNever = 'rds0' /* No schedule. */,
	DEVONthinkReminderScheduleOnce = 'rds1' /* One shot schedule. */,
	DEVONthinkReminderScheduleHourly = 'rds2' /* Hourly schedule. */,
	DEVONthinkReminderScheduleDaily = 'rds3' /* Daily schedule. */,
	DEVONthinkReminderScheduleWeekly = 'rds4' /* Weekly schedule. */,
	DEVONthinkReminderScheduleMonthly = 'rds5' /* Monthly schedule. */,
	DEVONthinkReminderScheduleYearly = 'rds6' /* Yearly schedule. */
};
typedef enum DEVONthinkReminderSchedule DEVONthinkReminderSchedule;

enum DEVONthinkReminderWeek {
	DEVONthinkReminderWeekNoWeek = 'rmw0' /* No week. */,
	DEVONthinkReminderWeekLastWeek = 'rmw5' /* Last week of month. */,
	DEVONthinkReminderWeekFirstWeek = 'rmw1' /* First week of month. */,
	DEVONthinkReminderWeekSecondWeek = 'rmw2' /* Second week of month. */,
	DEVONthinkReminderWeekThirdWeek = 'rmw3' /* Third week of month. */,
	DEVONthinkReminderWeekFourthWeek = 'rmw4' /* Fourth week of month. */
};
typedef enum DEVONthinkReminderWeek DEVONthinkReminderWeek;

enum DEVONthinkRuleEvent {
	DEVONthinkRuleEventNoEvent = 'rv00' /* No event. */,
	DEVONthinkRuleEventOpenEvent = 'rv05' /* Event after opening items. */,
	DEVONthinkRuleEventOpenExternallyEvent = 'rv06' /* Event after opening items externally. */,
	DEVONthinkRuleEventEditExternallyEvent = 'rv18' /* Event after editing items externally. */,
	DEVONthinkRuleEventLaunchEvent = 'rv07' /* Event after launching the URL of items. */,
	DEVONthinkRuleEventCreationEvent = 'rv01' /* Event after creating items. */,
	DEVONthinkRuleEventImportEvent = 'rv02' /* Event after importing items. */,
	DEVONthinkRuleEventClippingEvent = 'rv03' /* Event after clipping websites. */,
	DEVONthinkRuleEventDownloadEvent = 'rv04' /* Event after downloading items. */,
	DEVONthinkRuleEventRenameEvent = 'rv0C' /* Event after renaming items. */,
	DEVONthinkRuleEventMoveEvent = 'rv0A' /* Event after moving items. */,
	DEVONthinkRuleEventClassifyEvent = 'rv0B' /* Event after classifying items. */,
	DEVONthinkRuleEventReplicateEvent = 'rv0D' /* Event after replicating items. */,
	DEVONthinkRuleEventDuplicateEvent = 'rv0F' /* Event after duplicating items. */,
	DEVONthinkRuleEventTaggingEvent = 'rv0E' /* Event after tagging items. */,
	DEVONthinkRuleEventFlaggingEvent = 'rv13' /* Event after flagging items. */,
	DEVONthinkRuleEventLabellingEvent = 'rv12' /* Event after labelling items. */,
	DEVONthinkRuleEventRatingEvent = 'rv15' /* Event after rating items. */,
	DEVONthinkRuleEventMoveIntoDatabaseEvent = 'rv08' /* Event after consolidating items. */,
	DEVONthinkRuleEventMoveToExternalFolderEvent = 'rv09' /* Event after deconsolidating items. */,
	DEVONthinkRuleEventCommentingEvent = 'rv17' /* Event after commenting items. */,
	DEVONthinkRuleEventConvertEvent = 'rv14' /* Event after converting items. */,
	DEVONthinkRuleEventOCREvent = 'rv10' /* Event after performing OCR. */,
	DEVONthinkRuleEventImprintEvent = 'rv11' /* Event after imprinting items. */,
	DEVONthinkRuleEventTrashingEvent = 'rv16' /* Event before trashing items. */
};
typedef enum DEVONthinkRuleEvent DEVONthinkRuleEvent;

enum DEVONthinkSearchComparison {
	DEVONthinkSearchComparisonNoCase = 'noca' /* Case insensitive search. */,
	DEVONthinkSearchComparisonNoUmlauts = 'noum' /* Diacritics insensitive search. */,
	DEVONthinkSearchComparisonFuzzy = 'fuzz' /* Fuzzy search. */,
	DEVONthinkSearchComparisonRelated = 'simi' /* Related search. */
};
typedef enum DEVONthinkSearchComparison DEVONthinkSearchComparison;

enum DEVONthinkSummaryStyle {
	DEVONthinkSummaryStyleListSummary = 'SfLi' /* Bullet list summary. */,
	DEVONthinkSummaryStyleKeyPointsSummary = 'SfKy' /* Key points summary. */,
	DEVONthinkSummaryStyleTableSummary = 'SfTb' /* Table summary. */,
	DEVONthinkSummaryStyleTextSummary = 'SfTx' /* Text summary. */,
	DEVONthinkSummaryStyleCustomSummary = 'SfCs' /* Custom summary. */
};
typedef enum DEVONthinkSummaryStyle DEVONthinkSummaryStyle;

enum DEVONthinkSummaryType {
	DEVONthinkSummaryTypeMarkdown = 'mkdn' /* Markdown document */,
	DEVONthinkSummaryTypeSimple = 'ctp1' /* Plain text */,
	DEVONthinkSummaryTypeRich = 'ctp2' /* Rich text */,
	DEVONthinkSummaryTypeSheet = 'tabl' /* Sheet */
};
typedef enum DEVONthinkSummaryType DEVONthinkSummaryType;

enum DEVONthinkTagType {
	DEVONthinkTagTypeNoTag = 'ntag' /* No tag (not a group or excluded from tagging). */,
	DEVONthinkTagTypeOrdinaryTag = 'otag' /* An 'ordinary' tag located inside of the tags group. */,
	DEVONthinkTagTypeGroupTag = 'gtag' /* A 'group' tag located outside of the tags group. */
};
typedef enum DEVONthinkTagType DEVONthinkTagType;

enum DEVONthinkUpdateMode {
	DEVONthinkUpdateModeReplacing = 'UmRp' /* Replace text. */,
	DEVONthinkUpdateModeAppending = 'UmAp' /* Append text. */,
	DEVONthinkUpdateModeInserting = 'UmIn' /* Insert text */
};
typedef enum DEVONthinkUpdateMode DEVONthinkUpdateMode;

enum DEVONthinkOCRConvertType {
	DEVONthinkOCRConvertTypeAnnotateDocument = 'anno' /* Annotation */,
	DEVONthinkOCRConvertTypeCommentDocument = 'comt' /* Comment */,
	DEVONthinkOCRConvertTypePDFDocument = 'pdf ' /* PDF document */,
	DEVONthinkOCRConvertTypeRTF = 'rtf ' /* RTF document */,
	DEVONthinkOCRConvertTypeWordDocument = 'docx' /* Microsoft Word document */,
	DEVONthinkOCRConvertTypeWebarchive = 'wbar' /* Web Archive */
};
typedef enum DEVONthinkOCRConvertType DEVONthinkOCRConvertType;

enum DEVONthinkBorderStyleType {
	DEVONthinkBorderStyleTypeNone = 'ibs1' /* No border, this is the default */,
	DEVONthinkBorderStyleTypeRectangle = 'ibs2' /* Rectangular border */,
	DEVONthinkBorderStyleTypeRoundedRectangle = 'ibs3' /* Rectangle with rounded corners */,
	DEVONthinkBorderStyleTypeOval = 'ibs4' /* Oval border */,
	DEVONthinkBorderStyleTypeLeftArrow = 'ibs5' /* Left arrow */,
	DEVONthinkBorderStyleTypeRightArrow = 'ibs6' /* Right arrow */
};
typedef enum DEVONthinkBorderStyleType DEVONthinkBorderStyleType;

enum DEVONthinkImprintPosition {
	DEVONthinkImprintPositionTopLeft = 'ip01' /* Position imprint top left of page */,
	DEVONthinkImprintPositionTopCenter = 'ip02' /* Position imprint top center of page */,
	DEVONthinkImprintPositionTopRight = 'ip03' /* Position imprint top right of page */,
	DEVONthinkImprintPositionCenterLeft = 'ip04' /* Position imprint center left of page */,
	DEVONthinkImprintPositionCentered = 'ip05' /* Position imprint in the center of the page */,
	DEVONthinkImprintPositionCenterRight = 'ip06' /* Position imprint center right of page */,
	DEVONthinkImprintPositionBottomLeft = 'ip07' /* Position imprint bottom left of page */,
	DEVONthinkImprintPositionBottomCenter = 'ip08' /* Position imprint bottom center of page */,
	DEVONthinkImprintPositionBottomRight = 'ip09' /* Position imprint bottom right of page */
};
typedef enum DEVONthinkImprintPosition DEVONthinkImprintPosition;

enum DEVONthinkOccurrenceType {
	DEVONthinkOccurrenceTypeEveryPage = 'iot1' /* Imprint every page, this is the default */,
	DEVONthinkOccurrenceTypeFirstPageOnly = 'iot2' /* Imprint the first page only */,
	DEVONthinkOccurrenceTypeEvenPages = 'iot3' /* Imprint even pages only */,
	DEVONthinkOccurrenceTypeOddPages = 'iot4' /* Imprint odd pages only */
};
typedef enum DEVONthinkOccurrenceType DEVONthinkOccurrenceType;

@protocol DEVONthinkGenericMethods

- (void) closeSaving:(DEVONthinkSaveOptions)saving;  // Close a window, tab or database.
- (void) save;  // Save a window or tab.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a window or tab.
- (void) bold;  // Bold some text
- (void) italicize;  // Italicize some text
- (void) plain;  // Make some text plain
- (void) reformat;  // Reformat some text. Similar to WordService's Reformat service.
- (void) scrollToVisible;  // Scroll to and animate some text.
- (void) strike;  // Strike some text
- (void) unbold;  // Unbold some text
- (void) underline;  // Underline some text
- (void) unitalicize;  // Unitalicize some text
- (void) unstrike;  // Unstrike some text
- (void) ununderline;  // Ununderline some text
- (BOOL) addRowCells:(NSArray<NSString *> *)cells;  // Add new row to a sheet.
- (BOOL) deleteRowAtPosition:(NSInteger)position;  // Remove row at specified position from a sheet.
- (id) displayChatDialogName:(id)name role:(id)role prompt:(id)prompt;  // Display a dialog to show the response for a chat prompt for the current document. Either the selected text or the complete document is used.
- (id) getCellAtColumn:(id)column row:(NSInteger)row;  // Get content of cell at specified position of a sheet.
- (BOOL) setCellAtColumn:(id)column row:(NSInteger)row to:(NSString *)to;  // Set cell at specified position of a sheet.

@end



/*
 * Standard Suite
 */

// The application's top-level scripting object.
@interface DEVONthinkApplication : SBApplication

- (SBElementArray<DEVONthinkWindow *> *) windows;

@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the active application?
@property (copy, readonly) NSString *version;  // The version number of the application.

- (void) quitSaving:(DEVONthinkSaveOptions)saving;  // Quit the application.
- (BOOL) exists:(id)x;  // Verify that an object exists.
- (BOOL) addCustomMetaData:(id)x for:(NSString *)for_ to:(DEVONthinkRecord *)to as:(id)as;  // Add user-defined metadata to a record or updates already existing metadata of a record. Setting a value for an unknown key automatically adds a definition to Settings > Data.
- (BOOL) addDownload:(NSString *)x automatic:(BOOL)automatic password:(id)password referrer:(id)referrer user:(id)user;  // Add a URL to the download manager.
- (BOOL) addReadingListRecord:(id)record URL:(id)URL title:(id)title;  // Add record or URL to reading list.
- (id) addReminder:(NSDictionary *)x to:(DEVONthinkRecord *)to;  // Add a new reminder to a record.
- (NSInteger) checkFileIntegrityOfDatabase:(DEVONthinkDatabase *)database;  // Check file integrity of database.
- (id) classifyRecord:(DEVONthinkRecord *)record in:(id)in_ comparison:(DEVONthinkComparisonType)comparison tags:(BOOL)tags;  // Get a list of classification proposals.
- (id) compareRecord:(id)record content:(id)content to:(id)to comparison:(DEVONthinkComparisonType)comparison;  // Get a list of similar records, either by specifying a record or a content.
- (BOOL) compressDatabase:(DEVONthinkDatabase *)database password:(id)password to:(NSString *)to;  // Compress a database into a Zip archive.
- (id) convertRecord:(id)record to:(DEVONthinkConvertType)to in:(id)in_;  // Convert a record to plain or rich text, formatted note or HTML and create a new record afterwards.
- (id) convertFeedToHTML:(NSString *)x baseURL:(id)baseURL;  // Convert a RSS, RDF, JSON or Atom feed to HTML.
- (id) createDatabase:(NSString *)x encryptionKey:(id)encryptionKey size:(NSInteger)size;  // Create a new database.
- (id) createFormattedNoteFrom:(NSString *)x agent:(id)agent in:(id)in_ name:(id)name readability:(BOOL)readability referrer:(id)referrer source:(id)source;  // Create a new formatted note from a web page.
- (id) createLocation:(NSString *)x in:(id)in_;  // Create a hierarchy of groups if necessary.
- (id) createMarkdownFrom:(NSString *)x agent:(id)agent in:(id)in_ name:(id)name readability:(BOOL)readability referrer:(id)referrer;  // Create a Markdown document from a web resource.
- (id) createPDFDocumentFrom:(NSString *)x agent:(id)agent in:(id)in_ name:(id)name pagination:(BOOL)pagination readability:(BOOL)readability referrer:(id)referrer width:(NSNumber *)width;  // Create a new PDF document with or without pagination from a web resource.
- (id) createRecordWith:(NSDictionary *)x in:(id)in_;  // Create a new record.
- (BOOL) createThumbnailFor:(DEVONthinkRecord *)for_;  // Create or update existing thumbnail of a record. Thumbnailing is performed asynchronously in the background.
- (id) createWebDocumentFrom:(NSString *)x agent:(id)agent in:(id)in_ name:(id)name readability:(BOOL)readability referrer:(id)referrer;  // Create a new record (picture, PDF or web archive) from a web resource.
- (BOOL) deleteRecord:(id)record in:(id)in_;  // Delete all instances of a record from the database or one instance from the specified group.
- (BOOL) deleteThumbnailOf:(DEVONthinkRecord *)of;  // Delete existing thumbnail of a record.
- (BOOL) deleteWorkspace:(NSString *)x;  // Delete a workspace.
- (id) doJavaScript:(NSString *)x in:(id)in_;  // Executes a string of JavaScript code (optionally in the web view of a think window).
- (id) downloadImageForPrompt:(NSString *)x promptStrength:(double)promptStrength image:(id)image engine:(DEVONthinkImageEngine)engine quality:(NSString *)quality size:(NSString *)size style:(NSString *)style seed:(NSInteger)seed;  // Download image for a prompt.
- (id) downloadJSONFrom:(NSString *)x agent:(id)agent method:(id)method password:(id)password post:(id)post referrer:(id)referrer user:(id)user;  // Download a JSON object.
- (id) downloadMarkupFrom:(NSString *)x agent:(id)agent encoding:(id)encoding method:(id)method password:(id)password post:(id)post referrer:(id)referrer user:(id)user;  // Download an HTML or XML page (including RSS, RDF or Atom feeds).
- (id) downloadURL:(NSString *)x agent:(id)agent method:(id)method password:(id)password post:(id)post referrer:(id)referrer user:(id)user;  // Download a URL.
- (id) displayAuthenticationDialog;  // Display a dialog to enter a username and its password.
- (id) displayDateEditorDefaultDate:(id)defaultDate info:(id)info;  // Display a dialog to enter a date.
- (id) displayGroupSelectorButtons:(id)buttons for:(id)for_ name:(BOOL)name tags:(BOOL)tags;  // Display a dialog to select a (destination) group.
- (id) displayNameEditorDefaultAnswer:(id)defaultAnswer info:(id)info;  // Display a dialog to enter a name.
- (id) duplicateRecord:(id)record to:(DEVONthinkParent *)to;  // Duplicate a record.
- (BOOL) existsRecordAt:(NSString *)x in:(id)in_;  // Check if at least one record exists at the specified location.
- (BOOL) existsRecordWithComment:(NSString *)x in:(id)in_;  // Check if at least one record with the specified comment exists.
- (BOOL) existsRecordWithContentHash:(NSString *)x in:(id)in_;  // Check if at least one record with the specified content hash exists.
- (BOOL) existsRecordWithFile:(NSString *)x in:(id)in_;  // Check if at least one record with the specified last path component exists.
- (BOOL) existsRecordWithPath:(NSString *)x in:(id)in_;  // Check if at least one record with the specified path exists.
- (BOOL) existsRecordWithURL:(NSString *)x in:(id)in_;  // Check if at least one record with the specified URL exists.
- (id) exportRecord:(DEVONthinkRecord *)record to:(NSString *)to DEVONtech_Storage:(BOOL)DEVONtech_Storage;  // Export a record (and its children).
- (BOOL) exportTagsOfRecord:(DEVONthinkRecord *)record;  // Export Finder tags of a record.
- (id) exportWebsiteRecord:(DEVONthinkRecord *)record to:(NSString *)to template:(id)template_ indexPages:(BOOL)indexPages encoding:(id)encoding entities:(BOOL)entities;  // Export a record (and its children) as a website.
- (id) extractKeywordsFromRecord:(DEVONthinkRecord *)record barcodes:(BOOL)barcodes existingTags:(BOOL)existingTags hashTags:(BOOL)hashTags imageTags:(BOOL)imageTags;  // Extract list of keywords from a record. The list is sorted by number of occurrences.
- (id) getCachedDataForURL:(NSString *)x from:(id)from;  // Get cached data for URL of a resource which is part of a loaded webpage and its DOM tree, rendered in a think tab/window.
- (id) getChatCapabilitiesForEngine:(DEVONthinkChatEngine)x model:(NSString *)model;  // Retrieve capabilities of a model for a certain engine.
- (NSArray<NSString *> *) getChatModelsForEngine:(DEVONthinkChatEngine)x;  // Retrieve list of supported models of a chat engine.
- (id) getChatResponseForMessage:(id)x record:(id)record mode:(id)mode image:(id)image URL:(id)URL model:(id)model role:(id)role engine:(DEVONthinkChatEngine)engine temperature:(double)temperature thinking:(BOOL)thinking toolCalls:(BOOL)toolCalls usage:(DEVONthinkChatUsage)usage as:(id)as;  // Retrieve the response for a chat message. The chat might perform a web, Wikipedia or PubMed search if necessary depending on the parameters and the settings.
- (id) getConcordanceOfRecord:(DEVONthinkContent *)record sortedBy:(DEVONthinkConcordanceSorting)sortedBy;  // Get list of words of a record. Supports both documents and groups/feeds.
- (id) getCustomMetaDataDefaultValue:(id)defaultValue for:(NSString *)for_ from:(DEVONthinkRecord *)from;  // Get user-defined metadata from a record.
- (id) getDatabaseWithId:(NSInteger)x;  // Get database with the specified id.
- (id) getDatabaseWithUuid:(NSString *)x;  // Get database with the specified uuid.
- (id) getEmbeddedImagesOf:(NSString *)x baseURL:(id)baseURL fileType:(id)fileType;  // Get the URLs of all embedded images of an HTML page.
- (id) getEmbeddedObjectsOf:(NSString *)x baseURL:(id)baseURL fileType:(id)fileType;  // Get the URLs of all embedded objects of an HTML page.
- (id) getEmbeddedSheetsAndScriptsOf:(NSString *)x baseURL:(id)baseURL fileType:(id)fileType;  // Get the URLs of all embedded style sheets and scripts of an HTML page.
- (id) getFaviconOf:(NSString *)x baseURL:(id)baseURL;  // Get the favicon of an HTML page.
- (id) getFeedItemsOf:(NSString *)x baseURL:(id)baseURL;  // Get the feed items of a RSS, RDF, JSON or Atom feed.
- (id) getFramesOf:(NSString *)x baseURL:(id)baseURL;  // Get the URLs of all frames of an HTML page.
- (id) getItemsOfFeed:(NSString *)x baseURL:(id)baseURL;  // Get the items of a RSS, RDF, JSON or Atom feed as dictionaries. 'get feed items of' is recommended for new scripts.
- (id) getLinksOf:(NSString *)x baseURL:(id)baseURL containing:(id)containing fileType:(id)fileType;  // Get the URLs of all links of an HTML page.
- (id) getMetadataOf:(NSString *)x baseURL:(id)baseURL markdown:(id)markdown;  // Get the metadata of an HTML page or of a Markdown document.
- (id) getRecordAt:(NSString *)x in:(id)in_;  // Search for record at the specified location.
- (id) getRecordWithId:(NSInteger)x in:(id)in_;  // Get record with the specified id.
- (id) getRecordWithUuid:(NSString *)x in:(id)in_;  // Get record with the specified uuid or item link.
- (id) getRichTextOf:(NSString *)x baseURL:(id)baseURL;  // Get the rich text of an HTML page.
- (id) getTextOf:(NSString *)x;  // Get the text of an HTML page.
- (id) getTitleOf:(NSString *)x;  // Get the title of an HTML page.
- (id) getVersionsOfRecord:(DEVONthinkRecord *)record;  // Get saved versions of a record.
- (BOOL) hideProgressIndicator;  // Hide a visible progress indicator.
- (id) importAttachmentsOfRecord:(DEVONthinkRecord *)record to:(id)to;  // Import attachments of an email.
- (id) importPath:(NSString *)x from:(id)from name:(id)name placeholders:(id)placeholders to:(id)to;  // Import a file or folder (including its subfolders).
- (id) importTemplate:(NSString *)x to:(id)to;  // Import a template. Template scripts are not supported and revision-proof databases do not support any templates at all.
- (id) indexPath:(NSString *)x to:(id)to;  // Index a file or folder (including its subfolders). Not supported by revision-proof databases.
- (BOOL) loadWorkspace:(NSString *)x;  // Load a workspace.
- (BOOL) logMessageRecord:(id)record info:(id)info;  // Log info for a record, file or action to the Window > Log panel
- (id) lookupRecordsWithComment:(NSString *)x in:(id)in_;  // Lookup records with specified comment.
- (id) lookupRecordsWithContentHash:(NSString *)x in:(id)in_;  // Lookup records with specified content hash.
- (id) lookupRecordsWithFile:(NSString *)x in:(id)in_;  // Lookup records whose last path component is the specified file.
- (id) lookupRecordsWithPath:(NSString *)x in:(id)in_;  // Lookup records with specified path.
- (id) lookupRecordsWithTags:(NSArray<NSString *> *)x any:(BOOL)any in:(id)in_;  // Lookup records with all or any of the specified tags.
- (id) lookupRecordsWithURL:(NSString *)x in:(id)in_;  // Lookup records with specified URL.
- (id) mergeIn:(id)in_ records:(NSArray<DEVONthinkRecord *> *)records;  // Merge either a list of records as an RTF(D)/a PDF document or merge a list of not indexed groups/tags.
- (id) moveRecord:(id)record from:(id)from to:(DEVONthinkParent *)to;  // Move all instances of a record to a different group.  Specify the 'from' group to move a single instance to a different group.
- (BOOL) moveIntoDatabaseRecord:(DEVONthinkRecord *)record;  // Move an external/indexed record (and its children) into the database. Not supported by revision-proof databases.
- (BOOL) moveToExternalFolderRecord:(DEVONthinkRecord *)record to:(id)to;  // Move an internal/imported record (and its children) to the enclosing external folder in the filesystem. Creation/Modification dates, Spotlight comments and OpenMeta tags are immediately updated. Not supported by revision-proof databases.
- (id) openDatabase:(NSString *)x;  // Open an existing database.
- (id) openTabForRecord:(id)record URL:(id)URL referrer:(id)referrer in:(id)in_;  // Open a new tab for the specified URL or record in a think window.
- (id) openWindowForRecord:(DEVONthinkRecord *)record enforcement:(BOOL)enforcement;  // Open a (new) main or document window for the specified record. Only recommended for main windows, use 'open tab for' for document windows.
- (BOOL) optimizeDatabase:(DEVONthinkDatabase *)database;  // Backup & optimize a database.
- (id) pasteClipboardTo:(id)to;  // Create a new record with the contents of the clipboard.
- (BOOL) performSmartRuleName:(id)name record:(id)record trigger:(DEVONthinkRuleEvent)trigger;  // Perform one or all smart rules.
- (BOOL) refreshRecord:(DEVONthinkRecord *)record;  // Refresh a record. Currently only supported by feeds but not by revision-proof databases.
- (id) replicateRecord:(id)record to:(DEVONthinkParent *)to;  // Replicate a record.
- (BOOL) restoreRecordWithVersion:(DEVONthinkRecord *)version;  // Restore saved version of a record.
- (id) saveVersionOfRecord:(DEVONthinkRecord *)record;  // Save version of current record. NOTE: Use this command right before editing the contents, not afterwards, as duplicates are automatically removed.
- (BOOL) saveWorkspace:(NSString *)x;  // Save a workspace.
- (id) searchComparison:(DEVONthinkSearchComparison)comparison excludeSubgroups:(BOOL)excludeSubgroups in:(id)in_;  // Search for records in specified group or all databases.
- (BOOL) showProgressIndicator:(NSString *)x cancelButton:(BOOL)cancelButton steps:(NSNumber *)steps;  // Show a progress indicator or update an already visible indicator. You have to ensure that the indicator is hidden again via 'hide progress indicator' when the script ends or if an error occurs.
- (BOOL) showSearch;  // Perform search in frontmost main window. Opens a new main window if there's none.
- (BOOL) startDownloads;  // Start queue of download manager.
- (BOOL) stepProgressIndicator;  // Go to next step of a progress.
- (BOOL) stopDownloads;  // Stop queue of download manager.
- (id) summarizeAnnotationsOfIn:(id)in_ records:(NSArray<DEVONthinkContent *> *)records to:(DEVONthinkSummaryType)to;  // Summarize highlights & annotations of records. PDF, RTF(D), Markdown and web documents are currently supported.
- (id) summarizeContentsOfIn:(id)in_ records:(NSArray<DEVONthinkContent *> *)records to:(DEVONthinkSummaryType)to as:(DEVONthinkSummaryStyle)as;  // Summarize content of records.
- (id) summarizeMentionsOfIn:(id)in_ records:(NSArray<DEVONthinkContent *> *)records to:(DEVONthinkSummaryType)to;  // Summarize mentions of records.
- (id) summarizeText:(NSString *)x as:(DEVONthinkSummaryStyle)as;  // Summarizes text.
- (BOOL) synchronizeRecord:(id)record database:(id)database;  // Synchronizes records with the filesystem or databases with their sync locations. Only one of both operations is supported.
- (id) transcribeRecord:(DEVONthinkContent *)record language:(NSString *)language timestamps:(BOOL)timestamps;  // Transcribes speech, text or notes of a record.
- (BOOL) updateRecord:(DEVONthinkRecord *)record withText:(id)withText mode:(DEVONthinkUpdateMode)mode URL:(id)URL;  // Update text of a plain/rich text, Markdown document, formatted note or HTML page. Not supported by revision-proof databases.
- (BOOL) updateThumbnailOf:(DEVONthinkRecord *)of;  // Update existing thumbnail of a record. Thumbnailing is performed asynchronously in the background.
- (NSInteger) verifyDatabase:(DEVONthinkDatabase *)database;  // Verify a database.
- (id) convertImageRecord:(DEVONthinkContent *)record to:(id)to fileType:(DEVONthinkOCRConvertType)fileType waitingForReply:(BOOL)waitingForReply;  // Converts a record to a new record and applies OCR.
- (id) ocrFile:(NSString *)file attributes:(id)attributes to:(id)to fileType:(DEVONthinkOCRConvertType)fileType waitingForReply:(BOOL)waitingForReply;  // Imports a PDF document or image with OCR.
- (id) imprinterConfigurationNames;  // Returns list of imprinter configuration names
- (BOOL) imprintConfiguration:(NSString *)x to:(DEVONthinkContent *)to waitingForReply:(BOOL)waitingForReply;  // Imprint the record with a given imprinter configuration. Not supported by revision-proof databases.
- (BOOL) imprintRecord:(DEVONthinkContent *)record backgroundColor:(id)backgroundColor borderColor:(id)borderColor borderStyle:(DEVONthinkBorderStyleType)borderStyle borderWidth:(NSInteger)borderWidth font:(NSString *)font foregroundColor:(id)foregroundColor occurence:(DEVONthinkOccurrenceType)occurence outlined:(BOOL)outlined position:(DEVONthinkImprintPosition)position rotation:(NSInteger)rotation size:(NSInteger)size strikeThrough:(BOOL)strikeThrough text:(NSString *)text underlined:(BOOL)underlined xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset waitingForReply:(BOOL)waitingForReply;  // Imprint the record with a configuration defined in the parameters. Not supported by revision-proof databases.

@end

// A window.
@interface DEVONthinkWindow : SBObject <DEVONthinkGenericMethods>

@property (copy, readonly) NSString *name;  // The title of the window.
- (NSInteger) id;  // The unique identifier of the window.
@property NSInteger index;  // The index of the window, ordered front to back.
@property NSRect bounds;  // The bounding rectangle of the window.
@property (readonly) BOOL closeable;  // Does the window have a close button?
@property (readonly) BOOL miniaturizable;  // Does the window have a minimize button?
@property BOOL miniaturized;  // Is the window minimized right now?
@property (readonly) BOOL resizable;  // Can the window be resized?
@property BOOL visible;  // Is the window visible right now?
@property (readonly) BOOL zoomable;  // Does the window have a zoom button?
@property BOOL zoomed;  // Is the window zoomed right now?


@end



/*
 * Text Suite
 */

// Rich (styled) text
@interface DEVONthinkRichText : SBObject <DEVONthinkGenericMethods>

- (SBElementArray<DEVONthinkAttachment *> *) attachments;
- (SBElementArray<DEVONthinkAttributeRun *> *) attributeRuns;
- (SBElementArray<DEVONthinkCharacter *> *) characters;
- (SBElementArray<DEVONthinkParagraph *> *) paragraphs;
- (SBElementArray<DEVONthinkWord *> *) words;

@property (copy) id font;  // The name of the font of the first character.
@property (copy) NSNumber *size;  // The size in points of the first character.
@property (copy) id color;  // The color of the first character.

- (BOOL) addCustomMetaDataFor:(NSString *)for_ to:(DEVONthinkRecord *)to as:(id)as;  // Add user-defined metadata to a record or updates already existing metadata of a record. Setting a value for an unknown key automatically adds a definition to Settings > Data.

@end

// Represents an inline text attachment.  This class is used mainly for make commands.
@interface DEVONthinkAttachment : DEVONthinkRichText

@property (copy) id fileName;  // The path to the file for the attachment


@end

// This subdivides the text into chunks that all have the same attributes.
@interface DEVONthinkAttributeRun : SBObject <DEVONthinkGenericMethods>

- (SBElementArray<DEVONthinkAttachment *> *) attachments;
- (SBElementArray<DEVONthinkAttributeRun *> *) attributeRuns;
- (SBElementArray<DEVONthinkCharacter *> *) characters;
- (SBElementArray<DEVONthinkParagraph *> *) paragraphs;
- (SBElementArray<DEVONthinkWord *> *) words;

@property (copy) id font;  // The name of the font of the first character.
@property (copy) NSNumber *size;  // The size in points of the first character.
@property (copy) id color;  // The color of the first character.


@end

// This subdivides the text into characters.
@interface DEVONthinkCharacter : SBObject <DEVONthinkGenericMethods>

- (SBElementArray<DEVONthinkAttachment *> *) attachments;
- (SBElementArray<DEVONthinkAttributeRun *> *) attributeRuns;
- (SBElementArray<DEVONthinkCharacter *> *) characters;
- (SBElementArray<DEVONthinkParagraph *> *) paragraphs;
- (SBElementArray<DEVONthinkWord *> *) words;

@property (copy) id font;  // The name of the font of the first character.
@property (copy) NSNumber *size;  // The size in points of the first character.
@property (copy) id color;  // The color of the first character.


@end

// This subdivides the text into paragraphs.
@interface DEVONthinkParagraph : SBObject <DEVONthinkGenericMethods>

- (SBElementArray<DEVONthinkAttachment *> *) attachments;
- (SBElementArray<DEVONthinkAttributeRun *> *) attributeRuns;
- (SBElementArray<DEVONthinkCharacter *> *) characters;
- (SBElementArray<DEVONthinkParagraph *> *) paragraphs;
- (SBElementArray<DEVONthinkWord *> *) words;

@property (copy) id font;  // The name of the font of the first character.
@property (copy) NSNumber *size;  // The size in points of the first character.
@property (copy) id color;  // The color of the first character.


@end

// This subdivides the text into words.
@interface DEVONthinkWord : SBObject <DEVONthinkGenericMethods>

- (SBElementArray<DEVONthinkAttachment *> *) attachments;
- (SBElementArray<DEVONthinkAttributeRun *> *) attributeRuns;
- (SBElementArray<DEVONthinkCharacter *> *) characters;
- (SBElementArray<DEVONthinkParagraph *> *) paragraphs;
- (SBElementArray<DEVONthinkWord *> *) words;

@property (copy) id font;  // The name of the font of the first character.
@property (copy) NSNumber *size;  // The size in points of the first character.
@property (copy) id color;  // The color of the first character.


@end



/*
 * Extended Text Suite
 */

// Represents an inline text attachment.  This class is used mainly for make commands.
@interface DEVONthinkAttachment (ExtendedTextSuite)

@property (copy) id fileName;  // The path to the file for the attachment

@end

// Rich (styled) text
@interface DEVONthinkRichText (ExtendedTextSuite)

- (SBElementArray<DEVONthinkAttachment *> *) attachments;
- (SBElementArray<DEVONthinkAttributeRun *> *) attributeRuns;
- (SBElementArray<DEVONthinkCharacter *> *) characters;
- (SBElementArray<DEVONthinkParagraph *> *) paragraphs;
- (SBElementArray<DEVONthinkWord *> *) words;

@property double baselineOffset;  // Number of points shifted above or below the normal baseline.
@property (copy) id background;  // The background color of the first character.
@property double firstLineHeadIndent;  // Paragraph first line head indent of the text (always 0 or positive)
@property (copy) id font;  // The name of the font of the first character.
@property (copy) NSNumber *size;  // The size in points of the first character.
@property (copy) id color;  // The foreground color of the first character.
@property double headIndent;  // Paragraph head indent of the text (always 0 or positive).
@property BOOL underlined;  // Is the first character underlined?
@property double lineSpacing;  // Line spacing of the text.
@property double multipleLineHeight;  // Multiple line height of the text.
@property double maximumLineHeight;  // Maximum line height of the text.
@property double minimumLineHeight;  // Minimum line height of the text.
@property double paragraphSpacing;  // Paragraph spacing of the text.
@property NSInteger superscript;  // The superscript level of the text.
@property double tailIndent;  // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
@property (copy) id textContent;  // The actual text content.
@property DEVONthinkTextAlignment alignment;  // Alignment of the text.
@property (copy) id URL;  // Link of the text.

@end

// This subdivides the text into chunks that all have the same attributes.
@interface DEVONthinkAttributeRun (ExtendedTextSuite)

- (SBElementArray<DEVONthinkAttachment *> *) attachments;
- (SBElementArray<DEVONthinkAttributeRun *> *) attributeRuns;
- (SBElementArray<DEVONthinkCharacter *> *) characters;
- (SBElementArray<DEVONthinkParagraph *> *) paragraphs;
- (SBElementArray<DEVONthinkWord *> *) words;

@property double baselineOffset;  // Number of points shifted above or below the normal baseline.
@property (copy) id background;  // The background color of the first character.
@property double firstLineHeadIndent;  // Paragraph first line head indent of the text (always 0 or positive)
@property (copy) id font;  // The name of the font of the first character.
@property (copy) NSNumber *size;  // The size in points of the first character.
@property (copy) id color;  // The foreground color of the first character.
@property double headIndent;  // Paragraph head indent of the text (always 0 or positive).
@property BOOL underlined;  // Is the first character underlined?
@property double lineSpacing;  // Line spacing of the text.
@property double multipleLineHeight;  // Multiple line height of the text.
@property double maximumLineHeight;  // Maximum line height of the text.
@property double minimumLineHeight;  // Minimum line height of the text.
@property double paragraphSpacing;  // Paragraph spacing of the text.
@property NSInteger superscript;  // The superscript level of the text.
@property double tailIndent;  // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
@property (copy) id textContent;  // The actual text content.
@property DEVONthinkTextAlignment alignment;  // Alignment of the text.
@property (copy) id URL;  // Link of the text.

@end

// This subdivides the text into characters.
@interface DEVONthinkCharacter (ExtendedTextSuite)

- (SBElementArray<DEVONthinkAttachment *> *) attachments;
- (SBElementArray<DEVONthinkAttributeRun *> *) attributeRuns;
- (SBElementArray<DEVONthinkCharacter *> *) characters;
- (SBElementArray<DEVONthinkParagraph *> *) paragraphs;
- (SBElementArray<DEVONthinkWord *> *) words;

@property double baselineOffset;  // Number of points shifted above or below the normal baseline.
@property (copy) id background;  // The background color of the first character.
@property double firstLineHeadIndent;  // Paragraph first line head indent of the text (always 0 or positive)
@property (copy) id font;  // The name of the font of the first character.
@property (copy) NSNumber *size;  // The size in points of the first character.
@property (copy) id color;  // The foreground color of the first character.
@property double headIndent;  // Paragraph head indent of the text (always 0 or positive).
@property BOOL underlined;  // Is the first character underlined?
@property double lineSpacing;  // Line spacing of the text.
@property double multipleLineHeight;  // Multiple line height of the text.
@property double maximumLineHeight;  // Maximum line height of the text.
@property double minimumLineHeight;  // Minimum line height of the text.
@property double paragraphSpacing;  // Paragraph spacing of the text.
@property NSInteger superscript;  // The superscript level of the text.
@property double tailIndent;  // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
@property (copy) id textContent;  // The actual text content.
@property DEVONthinkTextAlignment alignment;  // Alignment of the text.
@property (copy) id URL;  // Link of the text.

@end

// This subdivides the text into paragraphs.
@interface DEVONthinkParagraph (ExtendedTextSuite)

- (SBElementArray<DEVONthinkAttachment *> *) attachments;
- (SBElementArray<DEVONthinkAttributeRun *> *) attributeRuns;
- (SBElementArray<DEVONthinkCharacter *> *) characters;
- (SBElementArray<DEVONthinkParagraph *> *) paragraphs;
- (SBElementArray<DEVONthinkWord *> *) words;

@property double baselineOffset;  // Number of points shifted above or below the normal baseline.
@property (copy) id background;  // The background color of the first character.
@property double firstLineHeadIndent;  // Paragraph first line head indent of the text (always 0 or positive)
@property (copy) id font;  // The name of the font of the first character.
@property (copy) NSNumber *size;  // The size in points of the first character.
@property (copy) id color;  // The foreground color of the first character.
@property double headIndent;  // Paragraph head indent of the text (always 0 or positive).
@property BOOL underlined;  // Is the first character underlined?
@property double lineSpacing;  // Line spacing of the text.
@property double multipleLineHeight;  // Multiple line height of the text.
@property double maximumLineHeight;  // Maximum line height of the text.
@property double minimumLineHeight;  // Minimum line height of the text.
@property double paragraphSpacing;  // Paragraph spacing of the text.
@property NSInteger superscript;  // The superscript level of the text.
@property double tailIndent;  // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
@property (copy) id textContent;  // The actual text content.
@property DEVONthinkTextAlignment alignment;  // Alignment of the text.
@property (copy) id URL;  // Link of the text.

@end

// This subdivides the text into words.
@interface DEVONthinkWord (ExtendedTextSuite)

- (SBElementArray<DEVONthinkAttachment *> *) attachments;
- (SBElementArray<DEVONthinkAttributeRun *> *) attributeRuns;
- (SBElementArray<DEVONthinkCharacter *> *) characters;
- (SBElementArray<DEVONthinkParagraph *> *) paragraphs;
- (SBElementArray<DEVONthinkWord *> *) words;

@property double baselineOffset;  // Number of points shifted above or below the normal baseline.
@property (copy) id background;  // The background color of the first character.
@property double firstLineHeadIndent;  // Paragraph first line head indent of the text (always 0 or positive)
@property (copy) id font;  // The name of the font of the first character.
@property (copy) NSNumber *size;  // The size in points of the first character.
@property (copy) id color;  // The foreground color of the first character.
@property double headIndent;  // Paragraph head indent of the text (always 0 or positive).
@property BOOL underlined;  // Is the first character underlined?
@property double lineSpacing;  // Line spacing of the text.
@property double multipleLineHeight;  // Multiple line height of the text.
@property double maximumLineHeight;  // Maximum line height of the text.
@property double minimumLineHeight;  // Minimum line height of the text.
@property double paragraphSpacing;  // Paragraph spacing of the text.
@property NSInteger superscript;  // The superscript level of the text.
@property double tailIndent;  // Paragraph tail indent of the text. If positive, it's the absolute line width. If 0 or negative, it's added to the line width.
@property (copy) id textContent;  // The actual text content.
@property DEVONthinkTextAlignment alignment;  // Alignment of the text.
@property (copy) id URL;  // Link of the text.

@end



/*
 * DEVONthink Suite
 */

// DEVONthink's top level scripting object.
@interface DEVONthinkApplication (DEVONthinkSuite)

- (SBElementArray<DEVONthinkDatabase *> *) databases;
- (SBElementArray<DEVONthinkThinkWindow *> *) thinkWindows;
- (SBElementArray<DEVONthinkMainWindow *> *) mainWindows;
- (SBElementArray<DEVONthinkDocumentWindow *> *) documentWindows;
- (SBElementArray<DEVONthinkSelectedRecord *> *) selectedRecords;

@property NSInteger batesNumber;  // Current bates number.
@property (readonly) BOOL cancelledProgress;  // Specifies if a process with a visible progress indicator should be cancelled.
@property (copy, readonly) id currentChatEngine;  // The default chat engine.
@property (copy, readonly) id currentChatModel;  // The default chat model.
@property (copy, readonly) id currentGroup;  // The (selected) group of the frontmost window of the current database. Returns root of current database if no current group exists.
@property (copy, readonly) id currentWorkspace;  // The name of the currently used workspace.
@property (copy, readonly) id currentDatabase;  // The currently used database.
@property (copy, readonly) id contentRecord;  // The record of the visible document in the frontmost think window.
@property (copy, readonly) id inbox;  // The global inbox.
@property (copy, readonly) id incomingGroup;  // The default group for new notes. Either global inbox or incoming group of current database if global inbox isn't available.
@property (copy, readonly) id labelNames;  // List of all 7 label names.
@property (copy, readonly) id lastDownloadedResponse;  // The last downloaded HTTP(S) response.
@property (copy, readonly) id lastDownloadedURL;  // The actual URL of the last download.
@property (copy, readonly) id preferredImportDestination;  // The default destination for data from external sources. See Settings > Import > Destination.
@property (copy, readonly) id readingList;  // The items of the reading list.
@property (copy, readonly) id selection;  // The current selection of the frontmost main window or the record of the frontmost document window. 'selected records' element is recommended instead especially for bulk retrieval of properties like UUID.
@property BOOL strictDuplicateRecognition;  // Specifies if recognition of duplicates is strict (exact) or not (fuzzy).
@property (copy, readonly) id workspaces;  // The names of all available workspaces.

@end

// A database.
@interface DEVONthinkDatabase : SBObject <DEVONthinkGenericMethods>

- (SBElementArray<DEVONthinkContent *> *) contents;
- (SBElementArray<DEVONthinkParent *> *) parents;
- (SBElementArray<DEVONthinkSmartParent *> *) smartParents;
- (SBElementArray<DEVONthinkTagGroup *> *) tagGroups;

- (NSInteger) id;  // The scripting identifier of a database.
@property (copy, readonly) id uuid;  // The unique and persistent identifier of a database for external referencing.
@property (copy, readonly) id annotationsGroup;  // The group for annotations, will be created if necessary.
@property (copy) id comment;  // The comment of the database.
@property (copy, readonly) id currentGroup;  // The (selected) group of the frontmost window. Returns root if no current group exists.
@property (copy, readonly) id incomingGroup;  // The default group for new notes. Might be identical to root.
@property (readonly) BOOL encrypted;  // Specifies if a database is encrypted or not.
@property (readonly) BOOL revisionProof;  // Specifies if a database is revision-proof or not.
@property (readonly) BOOL readOnly;  // Specifies if a database is read-only and can't be modified.
@property BOOL SpotlightIndexing;  // Specifies if Spotlight indexing of a database is en- or disabled.
@property BOOL versioning;  // Specifies whether versioning of documents is en- or disabled.
@property (copy) NSString *name;  // The name of the database.
@property (copy, readonly) id filename;  // The filename of the database.
@property (copy, readonly) id path;  // The POSIX path of the database.
@property (copy, readonly) id root;  // The top level group of the database.
@property (copy, readonly) id tagsGroup;  // The group for tags.
@property (copy, readonly) id trashGroup;  // The trash's group.
@property (copy, readonly) id versionsGroup;  // The group for versioning.


@end

// A database record.
@interface DEVONthinkRecord : SBObject <DEVONthinkGenericMethods>

- (SBElementArray<DEVONthinkChild *> *) children;
- (SBElementArray<DEVONthinkIncomingReference *> *) incomingReferences;
- (SBElementArray<DEVONthinkIncomingWikiReference *> *) incomingWikiReferences;
- (SBElementArray<DEVONthinkOutgoingReference *> *) outgoingReferences;
- (SBElementArray<DEVONthinkOutgoingWikiReference *> *) outgoingWikiReferences;
- (SBElementArray<DEVONthinkParent *> *) parents;

- (NSInteger) id;  // The scripting identifier of a record. Optimizing or closing a database might modify this identifier.
@property (copy, readonly) id MIMEType;  // The (proposed) MIME type of a record.
@property (copy, readonly) id uuid;  // The unique and persistent identifier of a record.
@property (copy, readonly) id additionDate;  // Date when the record was added to the database.
@property (copy) id aliases;  // Wiki aliases (separated by commas or semicolons) of a record.
@property double altitude;  // The altitude in metres of a record.
@property (copy) id annotation;  // Annotation of a record. Only plain & rich text and Markdown documents are supported. Read-only in case of revision-proof databases.
@property (readonly) NSInteger annotationCount;  // The number of annotations. Supported by HTML pages, formatted notes, web archives, PDF, rich text & Markdown documents.
@property (copy) id attachedScript;  // POSIX path of script attached to a record.
@property (readonly) NSInteger attachmentCount;  // The number of attachments. Currently only supported for RTFD documents and emails.
@property (copy) id attributesChangeDate;  // The change date of the record's attributes.
@property NSInteger batesNumber;  // Bates number.
@property (copy) NSArray<NSArray *> *cells;  // The cells of a sheet. This is a list of rows, each row contains a list of string values for the various colums. Read-only in case of revision-proof databases.
@property (readonly) NSInteger characterCount;  // The character count of a record.
@property (copy) id color;  // The color of a record. Currently only supported by tags & groups.
@property (copy, readonly) id columns;  // The column names of a sheet.
@property (copy) id comment;  // The comment of a record.
@property (copy, readonly) id contentHash;  // Stored SHA1 hash of files and document packages.
@property (copy) id creationDate;  // The creation date of a record. Read-only in case of revision-proof databases.
@property (copy) id customMetaData;  // User-defined metadata of a record as a dictionary containing key-value pairs. Setting a value for an unknown key automatically adds a definition to Settings > Data.
@property (copy) id data;  // The file data of a record. Currently only supported by PDF documents, images, rich text documents and web archives. Read-only in case of revision-proof databases.
@property (copy, readonly) id database;  // The database of the record.
@property (copy) id date;  // The (creation/modification) date of a record. Read-only in case of revision-proof databases.
@property (copy, readonly) id digitalObjectIdentifier;  // Digital object identifier (DOI) extracted from text of document, e.g. a scanned receipt, or from the title.
@property (copy, readonly) NSArray<NSNumber *> *dimensions;  // The width and height of an image or PDF document in pixels or points.
@property (copy, readonly) id documentAmount;  // Amount extracted from text of document, e.g. a scanned receipt.
@property (copy, readonly) id documentDate;  // First date extracted from text of document, e.g. a scan.
@property (copy, readonly) id allDocumentDates;  // All dates extracted from text of document, e.g. a scan.
@property (copy, readonly) id documentName;  // Name based on text or properties of document
@property (copy, readonly) NSNumber *dpi;  // The resultion of an image in dpi.
@property (copy, readonly) id duplicates;  // The duplicates of a record (only other instances, not including the record).
@property (readonly) double duration;  // The duration of audio and video files.
@property (readonly) BOOL encrypted;  // Specifies if a document is encrypted or not. Currently only supported by PDF documents.
@property BOOL excludeFromChat;  // Exclude group or record from chat.
@property BOOL excludeFromClassification;  // Exclude group or record from classifying.
@property BOOL excludeFromSearch;  // Exclude group or record from searching.
@property BOOL excludeFromSeeAlso;  // Exclude record from see also.
@property BOOL excludeFromTagging;  // Exclude group from tagging.
@property BOOL excludeFromWikiLinking;  // Exclude record from automatic Wiki linking.
@property (copy, readonly) id filename;  // The current filename of a record.
@property BOOL flag;  // The flag of a record.
@property (copy) id geolocation;  // The human readable geogr. location of a record.
@property (copy, readonly) NSNumber *height;  // The height of an image or PDF document in pixels or points.
@property (copy) id image;  // The image or PDF document of a record. Setting supports both raw data and strings containing paths or URLs. Read-only in case of revision-proof databases.
@property (readonly) BOOL indexed;  // Indexed or imported record.
@property (copy, readonly) id internationalStandardBookNumber;  // International standard book number (ISBN) extracted from text of document, e.g. a scanned receipt, or from the title.
@property double interval;  // Refresh interval of a feed. Currently overriden by settings.
@property (copy, readonly) id kind;  // The human readable and localized kind of a record. WARNING: Don't use this to check the type of a record, otherwise your script might fail depending on the version and the localization.
@property NSInteger label;  // Index of label (0-7) of a record.
@property (copy, readonly) id language;  // ISO code, e.g. 'en' or 'de', of language of document.
@property double latitude;  // The latitude in degrees of a record.
@property (copy, readonly) id location;  // The primary location of the record in the database as a POSIX path (/ in names is replaced with \/).
@property (copy, readonly) id locationGroup;  // The group of the record's primary location. This is identical to the first parent group.
@property (copy, readonly) id locationWithName;  // The full primary location of the record including its name (/ in names is replaced with \/).
@property BOOL locking;  // The locking of a record. Read-only in case of revision-proof databases.
@property double longitude;  // The longitude in degrees of a record.
@property (copy, readonly) id markdownSource;  // The Markdown source of a record if available or the record converted to Markdown if possible.
@property (copy, readonly) id metaData;  // Document metadata (e.g. of PDF & RTF documents, web pages or emails) of a record as a dictionary containing key-value pairs.
@property (copy) id modificationDate;  // The modification date of a record. Read-only in case of revision-proof databases.
@property (copy) NSString *name;  // The name of a record.
@property (copy, readonly) id nameWithoutDate;  // The name of a record without any dates.
@property (copy, readonly) id nameWithoutExtension;  // The name of a record without a file extension (independent of settings).
@property (copy, readonly) id newestDocumentDate;  // Newest date extracted from text of document, e.g. a scan.
@property (readonly) NSInteger numberOfDuplicates;  // The number of duplicates of a record.
@property NSInteger numberOfHits;  // The number of hits of a record.
@property (readonly) NSInteger numberOfReplicants;  // The number of replicants of a record.
@property (copy, readonly) id oldestDocumentDate;  // Oldest date extracted from text of document, e.g. a scan.
@property (copy, readonly) NSString *originalName;  // The original name of a record.
@property (copy, readonly) id openingDate;  // Date when a content was opened the last time or when a feed was refreshed the last time.
@property (readonly) NSInteger pageCount;  // The page count of a record. Currently only supported by PDF documents.
@property (copy, readonly) id paginatedPDF;  // A printed/converted PDF of the record.
@property (copy) id path;  // The POSIX file path of a record. Only the path of external records can be changed. Not accessible at all in case of revision-proof databases.
@property (readonly) BOOL pending;  // Flag whether the (latest) contents of a record haven't been downloaded from a sync location yet.
@property (copy) id plainText;  // The plain text of a record. Read-only in case of revision-proof databases. Setting this property of images, PDF documents, audio or video files sets the searchable, e.g. transcribed, text.
@property (copy, readonly) id proposedFilename;  // The proposed filename for a record.
@property NSInteger rating;  // Rating (0-5) of a record.
@property (readonly) DEVONthinkDataType recordType;  // The type of a record. WARNING: Don't use string conversions of this type for comparisons, this might fail due to known scripting issues of macOS.
@property (copy, readonly) id referenceURL;  // The URL (x-devonthink-item://...) to reference/link back to a record.
@property (copy) id reminder;  // Reminder of a record.
@property (copy) id richText;  // The rich text of the record (see extended text suite). Changes are only supported in case of RTF/RTFD documents and not by revision-proof databases.
@property (readonly) double score;  // The score of the last comparison, classification or search (value between 0.0 and 1.0) or undefined otherwise.
@property (readonly) NSInteger size;  // The size of a record in bytes.
@property (copy) id source;  // The HTML/XML source of a record if available or the record converted to HTML if possible. Read-only in case of revision-proof databases.
@property (readonly) DEVONthinkTagType tagType;  // The tag type of a record.
@property (copy) id tags;  // The tags of a record. Setting accepts both strings and parents.
@property (copy) id thumbnail;  // The thumbnail of a record. Setting supports both raw data and strings containing paths or URLs.
@property BOOL unread;  // The unread flag of a record.
@property (copy) id URL;  // The URL of a record. Read-only in case of bookmarks in revision-proof databases.
@property (copy, readonly) id webArchive;  // The web archive of a record if available or the record converted to web archive if possible.
@property (copy, readonly) NSNumber *width;  // The width of an image or PDF document in pixels or points.
@property (readonly) NSInteger wordCount;  // The word count of a record.


@end

// A child record of a group.
@interface DEVONthinkChild : DEVONthinkRecord


@end

// A content record of a database.
@interface DEVONthinkContent : DEVONthinkRecord


@end

// A reference from another record.
@interface DEVONthinkIncomingReference : DEVONthinkRecord


@end

// An automatic Wiki reference from another record. This depends on the current Wiki linking settings.
@interface DEVONthinkIncomingWikiReference : DEVONthinkRecord


@end

// A reference to another record.
@interface DEVONthinkOutgoingReference : DEVONthinkRecord


@end

// An automatic Wiki reference to another record. This depends on the current Wiki linking settings.
@interface DEVONthinkOutgoingWikiReference : DEVONthinkRecord


@end

// A parent (either group, feed or tag) of a record.
@interface DEVONthinkParent : DEVONthinkRecord


@end

// A reminder of a record.
@interface DEVONthinkReminder : SBObject <DEVONthinkGenericMethods>

@property DEVONthinkReminderAlarm alarm;  // Alarm of reminder.
@property (copy) id alarmString;  // Name of sound, text to speak, text of alert/notification, source/path of script or recipient of email. Text can also contain placeholders.
@property DEVONthinkReminderDay dayOfWeek;  // Scheduled day of week.
@property (copy) id dueDate;  // Due date.
@property NSInteger interval;  // Interval of schedule (every n hours, days, weeks, months or years)
@property NSInteger masc;  // Bitmap specifying scheduled days of week/month or scheduled months of year.
@property DEVONthinkReminderSchedule schedule;  // Schedule of reminder.
@property DEVONthinkReminderWeek weekOfMonth;  // Scheduled week of month.


@end

// A selected record.
@interface DEVONthinkSelectedRecord : DEVONthinkRecord


@end

// A smart group.
@interface DEVONthinkSmartParent : DEVONthinkRecord

@property BOOL excludeSubgroups;  // Exclude subgroups of the search group from searching.
@property BOOL highlightOccurrences;  // Highlight found occurrences in documents.
@property (copy) id searchGroup;  // Group of the smart group to search in.
@property (copy) id searchPredicates;  // A string representation of the conditions of the smart group.


@end

// A tag of a database.
@interface DEVONthinkTagGroup : DEVONthinkParent


@end

// A tab of a think window.
@interface DEVONthinkTab : SBObject <DEVONthinkGenericMethods>

- (NSInteger) id;  // The unique identifier of the tab.
@property (copy, readonly) id PDF;  // A PDF without pagination of the visible document retaining the screen layout.
@property (copy, readonly) id webArchive;  // Web archive of the current web page.
@property (readonly) NSInteger currentLine;  // Zero-based index of current line.
@property (copy, readonly) id currentMovieFrame;  // Image of current movie frame.
@property double currentTime;  // Time of current audio/video file.
@property NSInteger currentPage;  // Zero-based index of current PDF page.
@property (copy, readonly) id database;  // The database of the tab.
@property (copy, readonly) id contentRecord;  // The record of the visible document.
@property (readonly) BOOL loading;  // Specifies if the current web page is still loading.
@property (readonly) NSInteger numberOfColumns;  // Number of columns of the current sheet.
@property (readonly) NSInteger numberOfRows;  // Number of rows of the current sheet.
@property (copy, readonly) id paginatedPDF;  // A printed PDF with pagination of the visible document.
@property (copy, readonly) id referenceURL;  // The URL (x-devonthink-item://...) to reference/link back to the current content record and its selection, page, frame etc.
@property NSInteger selectedColumn;  // Index (1...n) of selected column of the current sheet.
@property (copy, readonly) NSArray<NSNumber *> *selectedColumns;  // Indices (1...n) of selected columns of the current sheet.
@property NSInteger selectedRow;  // Index (1...n) of selected row of the current sheet.
@property (copy, readonly) NSArray<NSNumber *> *selectedRows;  // Indices (1...n) of selected rows of the current sheet.
@property (copy, readonly) id source;  // The HTML source of the current web page.
@property (copy, readonly) id thinkWindow;  // The think window of the tab.
@property (copy) id URL;  // The URL of the current web page. In addition, setting the URL can be used to load a web page.
@property (copy) id selectedText;  // The rich text for the selection of the tab. Returns an empty string in case of no selection. Setting supports both text- and web-based documents, e.g. plain/rich text, Markdown documents or formatted notes. In addition, Markdown & HTML formatted input is supported too.
@property (copy, readonly) id plainText;  // The plain text of the tab.
@property (copy) id richText;  // The rich text of the tab. Changes are only supported in case of RTF/RTFD documents. In addition, Markdown & HTML formatted input is supported too.


@end

// A document window or main window.
@interface DEVONthinkThinkWindow : DEVONthinkWindow

- (SBElementArray<DEVONthinkTab *> *) tabs;

@property (copy, readonly) id PDF;  // A PDF without pagination of the visible document retaining the screen layout.
@property (copy, readonly) id webArchive;  // Web archive of the current web page.
@property (readonly) NSInteger currentLine;  // Zero-based index of current line.
@property (copy, readonly) id currentMovieFrame;  // Image of current movie frame.
@property double currentTime;  // Time of current audio/video file.
@property NSInteger currentPage;  // Zero-based index of current PDF page.
@property (copy) id currentTab;  // The selected tab of the think window.
@property (copy, readonly) id database;  // The database of the window.
@property (copy, readonly) id contentRecord;  // The record of the visible document.
@property (readonly) BOOL loading;  // Specifies if the current web page is still loading.
@property (readonly) NSInteger numberOfColumns;  // Number of columns of the current sheet.
@property (readonly) NSInteger numberOfRows;  // Number of rows of the current sheet.
@property (copy, readonly) id paginatedPDF;  // A printed PDF with pagination of the visible document.
@property (copy, readonly) id referenceURL;  // The URL (x-devonthink-item://...) to reference/link back to the current content record and its selection, page, frame etc.
@property NSInteger selectedColumn;  // Index (1...n) of selected column of the current sheet.
@property (copy, readonly) NSArray<NSNumber *> *selectedColumns;  // Indices (1...n) of selected columns of the current sheet.
@property NSInteger selectedRow;  // Index (1...n) of selected row of the current sheet.
@property (copy, readonly) NSArray<NSNumber *> *selectedRows;  // Indices (1...n) of selected rows of the current sheet.
@property (copy, readonly) id source;  // The HTML source of the current web page.
@property (copy) id URL;  // The URL of the current web page. In addition, setting the URL can be used to load a web page.
@property (copy) id selectedText;  // The rich text for the selection of the window. Returns an empty string in case of no selection or missing value in case of no tab/document. Setting supports both text- and web-based documents, e.g. plain/rich text, Markdown documents or formatted notes. In addition, Markdown & HTML formatted input is supported too.
@property (copy, readonly) id plainText;  // The plain text of the window.
@property (copy) id richText;  // The rich text of the window. Changes are only supported in case of RTF/RTFD documents. In addition, Markdown & HTML formatted input is supported too.


@end

// A document window.
@interface DEVONthinkDocumentWindow : DEVONthinkThinkWindow

@property (copy) id contentRecord;  // The record of the visible document.


@end

// A main window.
@interface DEVONthinkMainWindow : DEVONthinkThinkWindow

- (SBElementArray<DEVONthinkSelectedRecord *> *) selectedRecords;

@property (copy) id searchResults;  // The search results.
@property (copy) id root;  // The top level group of the window.
@property (copy) id searchQuery;  // The search query. Setting the query performs a search.
@property (copy) id selection;  // The current selection. 'selected records' element is recommended instead.


@end

