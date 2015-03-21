-- iR|HorrorClown//iR|PewX --
local screenWidth, screenHeight = guiGetScreenSize()
local calibri = dxCreateFont("calibri.ttf", 12/1080*screenHeight, false)
local leftTwidth = dxGetTextWidth("passed", 0.75, calibri)
local passedTwidth = dxGetTextWidth("left", 0.75, calibri)
local lessPixel = 40/1080*screenHeight
local lessPixel2 = 20/1080*screenHeight
local counter = 0
local frames = 0
local distanceToHunter = 0
local currentMap = "---"
local nextMap = "---"
local infoText = "---"
local xPoint = 0
local cServerInfosWidth = 0
local isMoveToRight = false
g_drawTimeleftBool = false
local infoTextAlpha = 255

local infoMSGs = {
"Kadir Nurman, der Erfinder des Dfners ist am 24.10.2013 verstorben",
"Eine 500 Euro-Banknote ist materialistisch gesehen nur 16 Cent wert.",
"Der Materialwert eines iPhones liegt bei 5% des Kaufpreises.",
"Wenn das Auge des Menschen digital wdre, so w?rde die Auflfsung 576 Megapixel betragen",
"Betrunkene Personen ?berleben lechter schwere Verletzungen",
"Snoop Dogg verkaufte wdhrend der Highschool Gras an Cameron Diaz",
"Das menschliche Gehirn verlangt instinktiv 4 Dinge: Essen, Sex, Wasser und Schlaf",
"Es gibt einen Regenraum in London, indem ?berall Regen fdllt, au?er da wo man steht.",
"Das menschliche Auge ist dazu in der Lage, vflliger Duneklheit, ein brennendes Streicholz auf 3 Kilometer zu erkennen.",
"Kreative Menschen denken zwar langsamer, haben aber einen hfheren IQ.",
"?ber 95% aller Menschen f?hlen sich unwohl, wenn die TV-Lautstdrke nicht durch 2 oder 5 teilbar ist.",
"In Schweden bezeichnet man ein Handy als 'Ficktelefon'.",
"Fast zwei Teelfffel Botox w?rden ausreichen, um die gesamte Weltbevflkerung zu vergiften.",
"Nachts ist es kdlter als drau?en.",
"Laut US-Studiean ist das Verstdndniss f?r hfhere Mathematik teilweise angeboren.",
"Durch die Nieren des Kfrpers flie?en pro Tag 1500 Liter Blut.",
"Morgens ist man zwei Zentimeter grf?er als Abends",
"die US-Armee verwendet Xbox.Controller zur Steuerung von Robotern.",
"Wenn du in Japan bei der Arbeit schldfst, zeigt das deinem Cheff, dass du hart arbeitest.",
"In Saudi-Arabien kostet das Trinkwasser mehr als Fl.",
"Eine Giraffe kann ihre Ohren mit der eigenen Zunge sdubern.",
"Anuptaphobie ist die Angst davor, f?r immer Singel zu bleiben.",
"1976 heiratete eine Frau einen 25kg schweren Felsen.",
"Die Verpackung von Cornflakes enthdlt mehr Ndhrstoffe als die Cornflakes in ihr.",
"Die CIA gehfrt zu den schlechtesten Geheimdiensten der Welt. Ihre 'Erfolgsbilanz' liegt bei 10%",
"Alle 60 Sekunden vergeht in Afrika eine Minute.",
"Alle neun Sekunden stirbt weltweit ein Mensch an den Folgen des Rauchens.",
"Der grf?te Mann der Welt hat zwei Beine.",
"Das Feruerzeug wurde vor dem Streichholz erfunden.",
"Die Amerikaner essen pro Tag durchschnittlich ezwas 73.000m² Pizza.",
"Flusspferde furzen durch den Mund.",
"Menschen die auf dem Bauch schlafen, neigen eher zu Trdumen mit sexuellen Inhalten.",
"Keine Freunde zu haben hat den selben schaden f?r die Gesundheit wie eine Packung Zigaretten am Tag.",
"Hdufiger Sex ldsst uns j?nger aussehen.",
"Soziale Medien sind s?chtigmachender als Alkohol und Zigaretten.",
"Erdbeeren kfnnen vor Krebs sch?tzen.",
"Die erste Atomatikuhr war eine Rolex.",
"Tdglich gibt es ?ber 3.000.000 erste Dates.",
"Mit einer einzigen Ejakulation eines Mannes kfnnte man theoretisch alle Frauen Europas befruchten.",
"Ein Gefdngnissausbruch ist keine Straftat.",
"Die tiefste Temperatur, die jemals auf der Erde gemessen wurde, betrdgt -89,2 °C, gemessen auf der Wostok-Station.",
"Eine der im Beipackzettel beschriebenen Nebenwirkungen von Aspirin sind Kopfschmerzen.",
"Die Simpsons ist die am ldngsten laufende US-Zeichentrickserie.",
"Der einzige nat?rliche Satellit der Erde ist der Mond.",
"Der Begriff Software existiert im heutigen Sinne erst seit 1958.",
"Im Pazifik schwimmt genug Plastikm?ll um die Fldche Texas zwei mal abzudecken.",
"Nach Verkaufszahlen hat jeder 10. Schweizer ein iPhone.",
"Die Erde ist keine Kugel. Sie ist ein Ellipsoid.",
"Buttermilch enthdlt keine Butter.",
"Die meisten Selbstmorde passieren an einem Montag.",
"Fl?stern ist anstregender f?r die Stimme als normales Sprechen.",
"Ein Mensch wiegt weniger, wenn der Mond genau ?ber ihm steht.",
"Es dauert bis zu 4 Stunden ein Strau?enei zuzubereiten.",
"Der Airbag in einem Auto fdllt unter das Sprengstoffgesetz in Deutschland.",
"Jeder Amerikaner isst in seinem Leben knapp 2000 mal bei McDonalds.",
"Ein Mensch kann durch einen Sprung auf ebenem Boden nicht ldnger als eine Sekunde in der Luft bleiben.",
"Barack Obama nahm als Teenager Drogen zu sich.",
"Die Zdhne von Krokodilen wachsen stdndig nach.",
"Der rechte Lungenfl?gel nimmt mehr Luft auf als der linke.",
"Der Begriff 'Klitoris' kommt urspr?nglich aus dem neugriechischen und bedeutet so viel wie kleiner H?gel.",
"Ted Turner aus der USA hdlt mit 30.000 Tieren etwa ein zehntel des Weltbestandes an Bisons.",
"Klaustrophobie beschreibt die Angst vor engen Rdumen.",
"Nirgendwo gibt es so viele Tornados wie in Florida.",
"Waldbrdnde breiten sich bergauf schneller aus als bergab.",
"Geht man von 70 Schldgen pro Minute aus, schldgt ein Herz 100.800 mal pro Tag.",
"Albert Einstein lehnte im Jahr 1952 das Amt des israelischen Staatsprdsidenten ab.",
"Jeder Zungenabdruck ist einzigartig.",
"Morologie ist die Lehre von der Dummheit.",
"Heizflr?cksto?abddmpfung ist das ldngste deutsche Wort ohne Doppelung von Buchstaben.",
"Von 13.983.816 Lottospielern wird im Durchschnitt nur einer 6 richtige tippen.",
"Die Erde wird z.B durch Meteoriten und Kometenstaub jeden Tag schwerer.",
"Adolf Hitler hatte nur einen Hoden.",
"Durch seine Einkerbungen kann ein Golfball bis zu vier mal weiter fliegen als ohne.",
"Pepperoni sind auf 50% der amerikanischen Pizzen zu finden.",
"Vier von zehn Kondomen werden an Frauen verkauft.",
"In Indien ist es mfglich Tiere zu heiraten.",
"Auf nahezu jedem Geldschein in den USA sind Spuren von Kokain zu finden.",
"Der elektrische Stuhl wurde durch einen Zahnarzt erfunden.",
"'Omniphobia' ist die Angst vor Allem.",
"Kdngurus kfnnen nicht r?ckwdrts laufen.",
"Eine Ameise kann das zehnfache ihres eigenen Kfrpergewichtes heben.",
"Die zwei T?rme des World Trade Centers hatten jeweils eine eigene Postleitzahl.",
"?pfel bestehen zu einem Viertel aus Luft.",
"Karate ist japanisch und bedeutet 'leere Hand'.",
"Unter 5% der Erdbevflkerung haben von Natur aus rote Haare.",
"Ein Hai erkennt Blut im Wasser schneller als jedes andere Tier.",
"Die Br?der Wright waren bei ihrem ersten Flug langsamer als ein mittelmd?iger 100m Ldufer.",
"Bei einem Schwein kann der Orgasmus bis zu 30 Minuten andauern.",
"Bis in das 19. Jahrhundert hinein wurden erfolglose Selbstmfrder in England hingerichtet.",
"Die Macher der Telenovela 'Verliebt in Berlin' wollten diese eigentlich 'Alles nur aus Liebe' nennen. Allerdings fanden sie die enstprechende Abk?rzung unpassend.",
"Nylonstrumpfhosen werden aus bis zu 10 km Nylonfaden produziert.",
"Krebse haben blaues Blut. ",
"In Deutschland sterben mehr Personen durch Verkehrunfdlle als durch Suizid.",
"Kamelmilch kann man nur k?nstlich gerinnen lassen, da ihr bestimmte Gerinnungsfaktoren fehlen.",
"Die erste Digitalkamera konnte Bilder nur mit 0,1 Megapixel Auflfsung schie?en.",
"Etwa ein Viertel aller Knochen eines Menschen befinden sich im Fu?.",
"Bei dem Versuch das Nie?en zu unterdr?cken kann man durch Rei?en von Blutgefd?en sterben.",
"Adolf Hitler wurde 1938 vom 'Time Magazine' zur Person des Jahres gewdhlt.",
"Das erste Telefonbuch aus dem Jahr 1878 bestand aus nur etwa 50 Namen.",
"Frauen haben eine hfhere Lebenserwartung als Mdnner.",
"Die letzten wirklich aus Gold hergestellten olympischen Medaillen gab es im Jahr 1912.",
"Das Christentum ist die grf?te Weltreligion.",
"Die Webseite von Yahoo hatte zu beginn den Namen 'Jerry's Guide to the World Wide Web'.",
"Aquaphobie ist die Angst vor Wasser.",
"In England bekommt etwa jeder zweite Hund ein Weihnachtsgeschenk.",
"Ein handels?blicher Strohhalm hat etwa 10 ml Fassungsvermfgen.",
"Das Land Japan besteht aus knapp 7.000 Inseln.",
"Der Kuwait-Dinar ist die 'teuerste' Wdhrung der Welt.",
"Das Spiel 'Die Sims' wurde ?ber 125 Millionen mal verkauft.",
"Das Summen einer Stubenfliege hat die Tonart 'F'.",
"Erhitzt man Eier in der Mikrowelle explodieren sie.",
"K?he lassen sich nicht eine Treppe herunter f?hren.",
"Katzen haben ?ber 30 Muskeln in ihren Ohren.",
"Moskitos besitzen Zdhne.",
"Der Rauch einer Zigarette besteht aus bis zu 12.000 Inhaltsstoffen.",
"Der Steueranteil bei Zigaretten liegt bei etwa 75%.",
"'Con' ist unter Windows ein reservierter Gerdtename. Daher kann man keinen Ordner mit diesem Namen anlegen.",
"Die Hfhe des Pariser Eifelturms variiert je nach Wetterlage um etwa 15 cm.",
"Ein Pferd kann kurzzeitig bis zu 15 PS an Leistung abrufen.",
"Der VW Kdfer war bis 2002 das meistverkaufte Auto der Welt.",
"Jedes Jahr ersticken bis zu 100 Menschen an verschluckten Kugelschreibern.",
"Die erste Kuh aus dem Milka-Werbespot hiess Adelheid.",
"Eine Pizza mit Radius z und Dicke a hat das Volumen 'Pi*z*z*a'.",
"In ihrer Anfangszeit kosteten Laserdrucker mindestens 100.000 Dollar.",
"Die 'Mona Lisa' hat keine Augenbrauen.",
"10% der Kfrperwdrme verliert ein Mensch ?ber den Kopf.",
"Jede Sekunde werden bis zu 30.000 Sex-Filme im Internet abgespielt.",
"Lego ist mit ?ber 300.000.000 Reifen pro Jahr der grf?te 'Reifenhersteller'.",
"Das am meisten verbreitete Hobby der Chinesen ist Briefmarken sammeln.",
"Ein Liter Mdusemilch kostet etwa 20.000?.",
"Blonde Bdrte wachsen schneller als dunkle Bdrte.",
"Wenn man ein St?ck Sellerie isst, verbraucht man mehr Kalorien als man zu sich nimmt.",
"Der US-B?rger gibt pro Jahr doppelt so viel Geld f?r Pornografie aus wie f?r Kekse.",
"1567 stolperte der Mann mit dem ldngsten Bart Europas ?ber eben diesen, st?rzte die Treppe herab und brach sich das Genick.",
"In Saudi-Arabien gibt es keinen einzigen Fluss.",
"Statt Toilettenpapier benutzten die alten Rfmer an Stfcken aufgespitzte Schwdmme.",
"Tabak rauchen ist zwar gesundheitsschddlich, das Essen aber nahrhaft.",
"In Los Angeles gibt es mehr Autos als Menschen.",
"Die Auster kann ihr Geschlecht beliebig oft dndern.",
"Das t?rkische Bad wurde von den Rfmern erfunden.",
"Krokodile schlucken Steine um tiefer tauchen zu kfnnen.",
"Wenn man vor Scham errftet, werden auch die Magenwdnde rot.",
"1971 wurde in London bei Christie's der Penis Napoleons versteigert.",
"Statistisch gesehen wird in den USA jeden Tag ein Mensch vom Blitz getftet.",
"im 16. Jahrhundert erlaubte ein Gesetz in England Mdnnern ihre Ehefrauen zu verpr?geln. Dies aber nur vor 10 Uhr.",
"Um Metall zu sparen wurden wdhrend des 2. Weltkrieges die Oscars aus Holz gefertigt.",
"Shrimps haben ihr Herz im Kopf.",
"Mehr als 50% der Tiere auf der Erde haben 6 Beine.",
"Durch Facebook wurden mehr als 5 Personen zu Milliarddren.",
"Ein Bleistift kann ?ber 50 km lang schreiben.",
"Der 'Candiru', ein S?sswasserfisch, wird auch Penisfisch genannt.",
"Lina Medina aus Peru bekam ihr erstes Kind im Alter von Knapp 6 Jahren.",
"Der Schachtarbeiter Les Colley wurde mit 93 Jahren Vater.",
"Moskitos paaren sich in der Regel in unter 10 Sekunden.",
"Der Darm eines Menschen ist grf?er als ein Tennisplatz.",
"Rund 10% aller Kinder glauben, dass Enten gelb sind.",
"Eine Heizung wird nicht schneller warm, wenn man sie voll aufdreht.",
"Tritt man gegen eine Laterne mit einer Quecksilberdampflampe, erlischt diese f?r bis zu 5 Minuten.",
"In Berlin gibt es mehr Br?cken als in Venedig.",
"Die Lebenslange Freiheitsstrafe dauert in Deutschland mindestens 15 Jahre.",
"In Japan ist die Zahl 4 eine Ungl?ckszahl.",
"Der Harn des Menschen enthdlt keine DNA.",
"Fledermduse schlafen bis zu 20 Stunden pro Tag.",
"Fingerndgel wachsen schneller als Fu?ndgel.",
"'Sitt' war der Versuch ein gegenteiliges Wort zu durstig einzuf?hren.",
"Die Schuhgrf?e der Freiheitsstatue ist im deutschen Ma?stab etwa 3500.",
"Der Mensch hat weniger Gene als einfacher Reis.",
"Albert EInstein konnte erst im Alter von 3 Jahren sprechen.",
"Speisesalz enthdlt bis zu 5% Wasser.",
"Der Airbus A380 ist das grf?te in Serie gefertigte zivile Verkehrsflugzeug.",
"Die Eigenbeteiligung f?r eine Pilotenausbildung kostet etwa das sechsfache eines First-Class-Flugs.",
"In S?dkorea starb 2002 ein Computerspieler, nachdem er 86 Stunden nichts gegessen und nicht geschlafen hatte.",
"Die iPhone-Applikation iRa Pro ist mit knapp 900 Euro die teuerste seiner Art.",
"Zwanghaftes Nasebohren heisst mit Fachbegriff 'Rhinotillexomanie'.",
"In Deutschland gibt es etwa 20.000.000 Verkehrsschilder. Dazu kommen ca. 3.500.000 Wegweiser.",
"Der Big Mac von McDonalds kostetete bei seiner Einf?hrung 1967 in Pennsylvania nur 45 cents.",
"Die Staatsverschuldung in Deutschland betrug 2011 pro Kopf ?ber 25.000?.",
"F?r Russen zwischen 25 und 50 Jahren ist Alkohol die am hdufigsten auftretende Todesursache.",
"Mfwen kfnnen salzhaltiges Meerwasser in ihrem Kfrper entsalzen.",
"Der Volvo V40 ist seit 2012 das erste Auto, welches mit einem Fu?gdngerairbag ausgestattet ist.",
"Jedes Jahr werden mehr als 45.000.000.000 H?hner geschlachtet.",
"Die strategische Flreserve Deutschlands betrug im Jahr 2005 ?ber 25 Millionen Tonnen.",
"Der erste iPod hatte 5 GB Speicherkapazitdt. Er wurde am 23. Oktober 2001 vorgestellt.",
"Das Spiel GTA V erzielte in den ersten drei Tagen nach der Verfffentlichung ?ber eine Milliarde Dollar Umsatz.",
"Deutsche Mdnner essen pro Tag etwa 100g Fleisch, Frauen nur etwa die Hdlfte.",
"Das meistverkaufte Eis der Welt ist Vanille-Eis.",
"Dies ist eine coole Infobox",
"Bei einer Massenpanik, ruhe bewahren!",
"Serverinhaber: HorrorClown",
"Forum: www.irace-mta.de",
"Teamspeak: ts.irace-mta.de",
"Teamspeak: ts.igaming-mta.de",
"Forum: www.igaming-mta.de",
"This is a cool information box",
"Keep calm at a stampede!",
"Love Dubstep <3!",
"Nützliche Informationen kannst du in unserer FAQ entnehmen",
"You can write an invite request in our forum (www.irace-mta.de) if you want to become a member",
"Du kannst eine Anfrage im Forum schreiben, wenn du Member werden möchtest",
"Keep calm and drop the bass :3",
"----> Hier könnte Ihre Werbung stehen <----",
"Unser Notendurchschnitt: 1,337",
"Bei einer Massenpanik, ruhe bewahren!",
"Bei Fragen, Probleme oder sonstigem, steht unser Team dir gerne zur verfügung (Teamspeak/Forum)",
"wahnung! killjaden isnt eh so gudda rayca",
"*____________________________________________*",
"Serverinhaber: HorrorClown",
"Dieser Moment, wenn du mit deiner Mutter einkaufen gehst, in der Hoffnung, dass sie dir irgendwas kauft, was du später eigentlich nicht brauchst",
"Dieser Moment, wenn du dir früher einen Ball unters Shirt getan hast und gesagt hast: Ich bin schwanger",
"Dieser Moment, wenn du neue Schuhe bekommst und sie in der Wohnung probe läufst",
"Dieser Moment, wenn man in einem Laden etwas kauft, es genau ansieht und zu Hause bemerkt, dass irgendetwas kaputt ist",
"Dieser Moment, wenn die Leute im Film alle Knochen brechen aber nach 2 Minuten weiterkämpfen wie die Weltmeister",
"Dieser Moment, wenn du von einem schlechten Lied ein Ohrwurm bekommst",
"Dieser Moment, wenn du Ja ich mach es gleich sagst und es kurz darauf wieder vergisst",
"Dieser Moment, wenn deine Mutter in dein Zimmer kommst, du so tust als würdest du schlafen und dann plötzlich lachen musst",
"Dieser Moment, wenn du in der Nacht aufwachst und meinst, plötzlich Leute oder Gesichter in deinem Zimmer zu erkennen",
"Dieser Moment, wenn man hundert mal zum Kühlschrank geht und trotzdem nichts isst",
"Dieser Moment, wenn dir beim Lernen die Wand irgendwie voll interessant vorkommt",
"Dieser Moment, wenn du den Papierkorb nicht triffst obwohl er nicht 1 Meter weg steht",
"Dieser Moment, wenn dir jemand entgegenkommt, du aber nicht weißt wo du hingucken sollst",
"Dieser Moment, wenn in einem Film ganze Magazine verballert werden aber nicht eine einzige Kugel trifft",
"Dieser Moment, wenn es dir vorkommt, als würde es stärker regnen wenn du schneller gehst",
"Dieser Moment, wenn du furzt und du dich darüber freust, wenn es stinkt",
"Dieser Moment, wenn du nachts auf die Toilette musst, dich aber nicht traust",
"Dieser Moment, wenn du merkst das Shampoo nicht so gut schmeckt wie es riecht",
"Dieser Moment, wenn man sein Zimmer aufräumt und danach nichts mehr findet",
"Dieser Moment, wenn man mit jemandem den man nicht so gut kennt, stundenlang chattet und sich auf der Straße nicht einmal grüßt",
"Dieser Moment, wenn man schon im Bett liegt, das Handy runterfällt und man versucht es aufzuheben ohne die Füße vom Bett zu nehmen",
"Dieser Moment, wenn du eine SMS erhälst und keine Ahnung hast, wem die Nummer gehört",
"Dieser Moment, wenn du die Schranktür öffnest und merkst das dir alles entgegen fällt und die Tür einfach wieder zuknallst",
"Dieser Moment, wenn du deinen Kaugummi nach 3 Minuten ausspuckst weil kein Geschmack mehr drauf ist und dir einen neuen nimmst",
"Dieser Moment, wenn man die Kinder morgens im Bus/Zug am liebsten erschießen möchte",
"Dieser Moment, wenn das Handy runterfällt und die Kopfhörer ihm das Leben retten",
"Dieser Moment, wenn man was will aber trotzdem nicht kriegt",
"Dieser Moment, wenn du eh schon zu spät los bist und jede Ampel plötzlich rot ist",
"Dieser Moment, wenn du deine Lieblingsserie schaust und deine Familie sich dazu entscheidet, einen wer kann am lautesten reden - Wettbewerb zu veranstalten",
"Dieser Moment, wenn das neue Handy zum ersten mal auf den Boden fällt",
"Dieser Moment, wenn du träumst, du fällst irgendwo runter und wachst geschockt im Bett auf",
"Dieser Moment, wenn du träumst, du wirst angeschossen, versuschst auszuweischen und wachst erschrocken auf",
"Dieser Moment, wenn im Unterricht auf einmal alle anfangen zu schrieben und du keine Ahnung hast, was du machen sollst",
"Dieser Moment, wenn du dringend etwas sagen möchtest es aber auf einmal vergisst",
"Dieser Moment, wenn du das Leckerste auf dem Teller bis zum Schluss aufhebst und es als letztes isst",
"Dieser Moment, wenn du dein Auto abschließt, 5 Meter läufst und du dir nichtmehr sicher bist, ob du es abgeschlossen hast",
"Dieser Moment, wenn man bei FIFA/PES so hart wie möglich auf die Knöpfe vom Kontroller drückt, in der Hoffnung schneller zu rennen",
"Dieser Moment, wenn du mit deinem Smartphone bei Facebook dein/e Ex stalkst und hoffst, dass du ihr/ihm nicht ausversehen eine Freundschaftsanfrage schickst",
"Dieser Moment, wenn du im Regen den Regenschirm aufmachst und es plötzlich aufhört zu regnen",
"Dieser Moment, wenn du zu jemandem sagst guck jetzt nicht nach rechts und er sofort nach rechts guckt",
"Dieser Moment, wenn du abends völlig erschöpft im Bett liegst und nicht schlafen kannst",
"Dieser Moment, wenn du in der Stadt neben deinen Eltern gehst etwas siehst und deine Eltern auf einmal weg sind",
"Dieser Moment, wenn dir ein Konterspruch 10 Minuten zu spät einfällt",
"Dieser Moment, wenn du die leere Milchpackung wieder in den Külschrank stellst, obwohl du weißt das sie in den Müll gehört",
"Dieser Moment, wenn man beim Arzt einen Termin hat aber trotzdem eine halbe Stunde warten muss",
"Dieser Moment, wenn man sein Zimmer entstaubt und es am nächsten Tag wieder so aussieht wie vorher",
"Dieser Moment, wenn das Tischtuch dein Knie berührt und du meinst es sei ein Insekt",
"Dieser Moment, wenn man wie ein Irrer über die Straße rennt, obwohl das Auto noch 1 Kilometer entfernt ist",
"Dieser Moment, wenn eine Fliege solange nervt, bist man aufsteht um sie zu erledigen und sie dann erst wieder auftaucht, wenn man wieder gemütlich sitzt",
"Dieser Moment, wenn du dir als Kind Regen gewünscht hast, nur um deine neuen Gummistiefel zu testen",
"Dieser Moment, wenn du in der Dusche auf einmal wie ein Profi singen kannst",
"Dieser Moment, wenn dir unter der Decke viel zu warm ist, du deinen Fuß rausstreckst und es dann die perfekte Temperatur zum Schlafen ist",
"Dieser Moment, wenn du nachts den Lichtschalter suchst",
"Dieser Moment, wenn man hofft sich beim Postkarte schreiben nicht zu verschreiben",
"Dieser Moment, wenn deine Eltern arbeiten, du den ganzen Tag auf der Couch liegst und TV guckst und wenn sie nach Hause kommen, springst du auf und tust so als ob du etwas im Haushalt machen würdest",
"Dieser Moment, wenn du früher 'der Luftballon darf den Boden nicht berühren' gespielt hast",
"Dieser Moment, wenn man hofft, dass sich im Bus niemand neben dich sitzt",
"Dieser Moment, wenn du plötzlich beim spazieren, Spinnenweben quer ins Gesicht bekommst",
"Dieser Moment, wenn du mitten in der Nacht aufwachst und es erst 3 uhr ist und du denkst yeah ich kann noch schlafen bis der Wecker um 6 klingelt",
"Dieser Moment, wenn du dein Pc einschaltest und du dann noch auf die Toilette gehst bis der PC hochgefahren ist",
"Dieser Moment, wenn du schnell ein Foto machen willst und später bemerkst, dass es im Videomodus war",
"Dieser Moment, wenn du deine Kopfhörer aus der Tasche holst und ein 4-facher Knoten darin ist",
"Dieser Moment, wenn du deine Überraschung schon kennst aber so tun musst als ob du es nicht wüsstest",
"Dieser Moment, wenn du den Torwart ausdribbelst und daneben schießt",
"Dieser Moment, wenn du die Ruhe endlich genießen kannst und das Telefen klingelt",
"Dieser Moment, wenn du neben deinem Lichtschalter stehst, dir den Weg zu deinem Bett merkst, das Lich ausmachst und losrennst",
"Dieser Moment, wenn du das Wort Gähnen liesdt und dann gähnen musst",
"Dieser Moment, wenn du die Zeitschrift umblättern willst und sie unten entreißt",
"Dieser Moment, wenn du laut Musik hörst und dir dauernd einbildest deine Mutter würde dich rufen",
"Dieser Moment, wenn dich jemand bei Facebook anstupst, du zurückstupst und es immer so weiter geht",
"Dieser Moment, wenn du einen falschen Buchstaben tippst und du sofort das ganze Wort löschst",
"Dieser Moment, wenn es nur noch eine Pizza gibt",
"Dieser Moment, wenn du duschen musst, aber keine Lust hast, dann aber nicht aus der Dusche raus willst, wenn du fertig bist",
"Dieser Moment, wenn man unter der Dusche steht und vergessen hat, das Handtuch bereit zu legen",
"Dieser Moment, wenn du früher deinem Kuscheltier die Klamotten ausziehen wolltest und dann gemerkt hast, dass sie festgenäht sind",
"Dieser Moment, wenn man sein Passwort 100 mal eingibt und dann erst bemerkt, dass die Feststelltaste aktiviert ist",
"Dieser Moment, wenn du was suchst, zu Hause es nicht findest und am nächsten Tag findest aber du brauchst es nichtmehr",
"Dieser Moment, wenn etwas stinkt und man trotzdem nochmal daran riecht",
"Dieser Moment, wenn alle anderen Kassen im Supermarkt schneller sind als Deine",
"Dieser Moment, wenn deine Mutter grundlos in dein Zimmer kommt, wieder rausgeht und die Tür offen lässt",
"Dieser Moment, wenn du versuchst deinen Laptop mit einer Hand aufzuklappen und dabei die untere Hälfte mitkommt",
"Dieser Moment, wenn du einen Schluck Wasser trinkst und dir dann plötzlich der Klodeckel auf den Kopf knallt",
"Dieser Moment, wenn du gerade deine Lieblingssendung schaust und Mama anfängt zu staubsaugen",
"Dieser Moment, wenn man furzt und es kommt Land mit",
"Dieser Moment, wenn du eine Flasche aufdrehst und du hast Angst, dass sie überläuft",
"Dieser Moment, wenn Harro von Galileo überall auf der Welt Deutsch redet und ihn jeder versteht",
"Dieser Moment, wenn es während der Schulzeit richtig warm ist und in den Ferien jeden Tag schlechtes Wetter ist",
"Dieser Moment, wenn ein Baby nur ein Finger von dir hält",
"Dieser Moment, wenn du im gesamten Haus nach Essen suchst sobald deine Eltern weg sind",
"Dieser Moment, wenn man sich erst erinnert, nicht die Zähne geputzt zu haben, wenn man sich schon im Bett eingekuschelt hat",
"Dieser Moment, wenn du die elektrische Zahnbürste anschaltest, bevor sie im Mund ist",
"Dieser Moment, wenn du im Bus/Bahn sitzt und dich eine ältere Person zutextet und du nur denkst 'Warum ich?'",
"Dieser Moment, wenn dir etwas runterfällt und du es Ninjamäßig auffängst",
"Dieser Moment, wenn du jemanden erschrecken willst, dich aber dabei mehr erschreckst als der andere",
"Dieser Moment, wenn sich alle Nachbarn absprechen, um Sonntag früh nacheinander Rasen zu mähen",
"Dieser Moment, wenn du an irgendetwas schuld bist aber deine Freunde den Ärger bekommen",
"Dieser Moment, wenn man sich alte Bilder anschaut und sich denkt 'Oh man wie konnte ich nur so rumlaufen'",
"Dieser Moment, wenn du morgens was dringendes vor hast und trotzdem noch eine halbe Stunde länger schläfst",
"Dieser Moment, wenn du niesen musst aber der Nieser nicht rauskommt",
"Dieser Moment, wenn du mit dem Auto zu Hause angekommen bist im Radio läuft dein Lieblingslied und du deswegen nocht nicht aussteigst",
"Dieser Moment, wenn du versuchst den Lichtschalter genau in der Mitte an- und auszumachen",
"Dieser Moment, wenn man beim pinkeln im Stehen auf die Klobrille pinkelt",
"Dieser Moment, wenn du einschalfen willst und dein Gehirn einfach nicht die Fresse halten will",
"Dieser Moment, wenn du in ein Spinnennetz läufst, dass du nicht gesehen hast",
"Dieser Moment, wenn das einzige, dass du von den AGB's ließt, der Satz 'Ich habe die AGB gelesen und bin damit einverstanden' ist",
"Dieser Moment, wenn du in der Bahn sitzt, es plötzlich anfängt zu stinken und du das Gefühl hast, dass alle anderen dich verdächtigen",
"Dieser Moment, wenn du beim Einschlafen zusammenzuckst",
"Dieser Moment, wenn du im Bett liegst und du mit Füßen nach kalte Stellen suchst",
"Dieser Moment, wenn man zur Musik mitsingt und das Fenster offen ist und dich die Nachbarn danach immer komsich anschauen",
"Dieser Moment, wenn du jemanden eine Nachricht gesendet hast und auf eine Antwort wartest, derjenige in der Weile 10tausend Sachen liked aber dir nicht zurückschreibt und du dich fühlst als würdest du für dumm gehalten werden",
"Dieser Moment, wenn die Cornflakes schon in der Schüssel sind, du aber bemerkst, dass die Milch schon leer ist",
"Dieser Moment, wenn du die Chicken MCNuggats Box aufmachst und hoffst, dass die sich verzählt haben",
"Dieser Moment, wenn du erfährst dass dein Vater nicht dein Vater ist",
"Dieser Moment, wenn du dir was richtig Leckeres zu essen gekauft hast, dich richtig darauf freust und es dir dann runterfällt",
"Dieser Moment, wenn du einen 'Dieser Moment, wenn...' Spruch liest und froh bist, dass es nicht nur dir so geht",
"Dieser Moment, wenn man sich fragt, warum es in WhatsApp nen lächelnden Scheisshaufen gibt",
"Dieser Moment, wenn du Recht hast, dir aber keiner glaubt",
"Dieser Moment, wenn man sein Pausenbrot schon zum Frühstuck gegessen hat",
"Dieser Moment, wenn man eine SMS schreibt und alle plötzlich auf dein Handy gucken",
"Dieser Moment, wenn man im Keller das Lich ausmacht und sofort um sein Leben rennt",
"Dieser Moment, wenn du im Bett liegst, mit deinem Handy etwas schreibst und es dir prompt aufs Gesicht fällt",
"Dieser Moment, wenn deine Mutter dich Fragt: Hast du dein Zimmer aufgeräumt und du sagst JAA",
"Dieser Moment, wenn man etwas heißes anpackt und sofort wieder los lässt, weil man weiß, dass der Schmerz erst in 2 Sekunden kommt",
"Dieser Moment, wenn du in die Sonne guckst und du plötzlich nießen musst",
"Dieser Moment, wenn du dich nachts ins Bett legst und plötzlich wieder hellwach bist",
"Dieser Moment, wenn du eine Benachrichtigung bei Facebook bekommst, dich darüber freust aber dann siehst, dass es nur eine Spielanfrage ist",
"Dieser Moment, wenn das Popcorn schon alle ist, bevor der Kinofilm überhaupt angefangen hat",
"Dieser Moment, wenn du popelst und den Popel heimlich auf dem Sofa abschmierst",
"Dieser Moment, wenn man die Tüte zu doll aufreißt und fast alle Bonbons auf den Boden fallen",
"Dieser Moment, wenn man jemanden verletzt und dann nur so tut als hätte man sich selbst dabei verletzt",
"Dieser Moment, wenn du hörst, dass deine Mutter nach Hause kommt und dir einfällt, dass sie dich um einen Gefallen gebeten hat",
"Dieser Moment, wenn du denkst, das hätte ich wissen müssen",
"Dieser Moment, wenn du in der Schule schlecht bist, dir sagst 'Ich werde alles Besser machen' und in einer Woche wieder alles beim alten ist",
"Dieser Moment, wenn du etwas sagen willst, dich ein anderer unterbricht und du vergessen hast was du sagen wolltest",
"Dieser Moment, wenn du eine Wespe killst und befürchtest, dass jeden Augenblick die Familie der Wespe kommt, um sie zu rächen",
"Dieser Moment, wenn du total kaputt bist und schlafen willst, aber deine Gedanken einfach nicht zur Ruhe kommen",
"Dieser Moment, wenn du bei einer älteren Person nicht weißt, ob du sie duzen oder siezen sollst",
"Dieser Moment, wenn du merkst, das 95% der 'Dieser Moment' Sprüche auf dich zutreffen",
"Dieser Moment, wenn du von der Schule oder Arbeit nach Hause kommst und direkt eine bequeme Hose anziehst",
"Dieser Moment, wenn du beim telefonieren die ganze Zeit auf einem Zettel rummalst",
"Dieser Moment, wenn du dir für den nächsten Tag total viel vornimmst, dann aber nichts davon machst",
"Dieser Moment, wenn du auf der Toilette bist und plötzlich bemerkst, dass das Klopapier leer ist",
"Dieser Moment, wenn man zu seinem Auto kommt und es die ganze Zeit in der prallen Sonne stand",
"Dieser Moment, wenn du ein Wort wieder und wieder sagst und es plötzlich total bescheuert klingt",
"Dieser Moment, wenn man Facebook schließt und nach ein paar Minuten unbewusst wieder öffnet",
"Dieser Moment, wenn du den ganzen Tag mit Freunden im Schwimmbad warst, aber keiner mal zwischendurch auf die Toilette musste",
"Dieser Moment, wenn du im Supermarkt an der Kasse stehst und vor dir an der kasse eine ältere Person ihr Kleingeld zählt",
"Dieser Moment, wenn dir abends sobald du im Bett liegst einfällt, dass du noch Hausaufgaben machen musst",
"Dieser Moment, wenn du alleine zu Haus bist, auf der Toilette sitzt und es dann an der Tür klingelt",
"Dieser Moment, wenn du dir denkst 'Nie wieder Alkohol', zumindest für eine gewisse Zeit",
"Dieser Moment, wenn dein Lehrer dich dran nimmt und du keinen blassen Schimmer hast, worum es geht",
"Dieser Moment, wenn jemand mit Karte zahlt, seinen Pin eingibt und jeder sich automatisch wegdreht",
"Dieser Moment, wenn du Kopfhörer im Ohr hast und plötzlich jeder mit dir reden möchte",
"Dieser Moment, wenn es viel zu warm ist, du dir aber trotzdem die Decke zwischen die Beine klemmst",
"Dieser Moment, wenn du im Sportunterricht sagst du hast deine Tage, damit du nicht mitmachen musst",
"Dieser Moment, wenn du 5 Minuten bevor du gehst noch dein Handy auflädst, weil du denkst, dass es noch etwas bringt",
"Dieser Moment, wenn man an einem Spiegel vorbei geht und reinschauen muss",
"Dieser Moment, wenn du ohne was zu kaufen an der Kasse vorbeiläufst und dir denkst: 'Jetzt nicht Kriminell aussehen'",
"Dieser Moment, wenn man auf der Couch sitzt und dann bemerkt, dass jemand die Fernbedienung neben den Fernseher gelegt hat",
"Dieser Moment, wenn das einzige Licht in der Nacht das Display deines Handys ist und alle Viecher vor deiner Nase am Handy rumfliegen",
"Dieser Moment, wenn man einen tollen Traum hat, aufwacht und dann versucht wieder einzuschlafen, um genau an der Stelle weiter zu träumen",
"Dieser Moment, wenn man erst nach dem Klausur das Thema versteht",
"Dieser Moment, wenn man sich von jemanden verabschiedet und doch in die selbe Richtung laufen muss",
"Dieser Moment, wenn man versucht eine Tür aufzuziehen, wo dick und fett drauf steht 'Drücken'",
"Dieser Moment, wenn der Bus direkt vor deiner Nase wegfährt, obwohl der Busfahrer dich gesehen haben muss",
"Dieser Moment, wenn man in Whatsapp sieht, das jemand die Nachricht gelesen hat,  die Person aber einfach nicht antwortet",
"Dieser Moment, wenn man 'Was?' fragt, obwohl man es verstanden hat, aber etwas Zeit gewinnen will um darüber nachzudenken",
"Dieser Moment, wenn man als Kind das perfekte Versteck beim Spielen gefunden hat und dann auf's Klo muss",
"Dieser Moment, wenn du im Bett liegst, du aufs Klo musst und dir überlegst, ob es sich rentiert zu gehen oder ob du es bis morgen aufhalten willst",
"Dieser Moment, wenn deine Hand nichtmehr in die Chipdose passt",
"Dieser Moment, wenn man einen Raum betritt, vergisst, was man wollte und zurückgeht, damit es einem wieder einfällt",
"Dieser Moment, wenn man seine eigene Stimme in einem Video/Audioaufnahme hört und sich denkt, man hör ich mich beschissen an",
"Dieser Moment, wenn du mit deinen Eltern einen Film guckst; eine Sexszene vorkommt und du dich schnell mit irgendetwas anderem beschäftigst",
"Dieser Moment, wenn du aufs Klo willst und es besetzt ist du aber danach nicht mehr musst",
"Dieser Moment, wenn es Sonntagabend ist und dir dann erst einfällt, dass du noch Hausaufgaben auf hattest",
"Dieser Moment, wenn du den Test gut fandest und es doch nur eine 5 wurde",
"Dieser Moment, wenn man ein Loch zunäht, es dann mehrmals an derselben Stelle näht damit es auch wirklich hält",
"Dieser Moment, wenn man zu spät zur Schule kommt, vor der Klassentür steht und nicht weiß, ob man klopfen soll",
"Dieser Moment, wenn alle Ausländer nach den Ferien Markenklamotten anhaben",
"Dieser Moment, wenn du nachts den Lichschalter suchst",
"Dieser Moment, wenn du das Telefon suchst, es endlich gefunden hast, drangehst und derjenige gerade aufgelegt hat",
"Dieser Moment, wenn dein Wecker klingelt, du ihn wegdrückst und dann verschläfst",
"Dieser Moment, wenn du dir beim Schminken wünschst, dass einmal beide Augen gleich aussehen",
"Dieser Moment, wenn du ein Bild kommentierst, du dir danach die Kommentare liest und du merkst, dass jemand direkt vor dir exakt dasselbe geschrieben hat",
"Dieser Moment, wenn jemand in dein Zimmer kommt, wieder rausgeht und dann die Tür offen lässt",
"Dieser Moment, wenn deine Eltern kindischer sind als du",
"Dieser Moment, wenn du im Klassenzimmer aus großer Entfernung in den Papierkorb wirfst, triffst und dir denkst >>Like A Boss<<",
"Dieser Moment, wenn bei einem traurigen Film anfängt das Auge zu jucken",
"Dieser Moment, wenn du Wörter auf deinem Taschenrechner tippst und deinem Banknachbarn stolz präsentierst",
"Dieser Moment, wenn du im Kino sitzt und dann aufs Klo musst",
"Dieser Moment, wenn du auf die Uhr schaust und du dann immer noch nicht weißt wie spät es ist",
"Dieser Moment, wenn du Blödsinn mitmachst und der einzige bist der erwischt wird",
"Dieser Moment, wenn sich eine Fliege auf deinem PC-Bildschirm niederlässt und du versuchst, sie mit dem Mauszeiger zu vertreiben",
"Dieser Moment, wenn du dich über die offen stehende Zimmertür aufregst und dich dann fragst warum du sie nicht beim Reinkommen zu gemacht hast",
"Dieser Moment, wenn du dich an der Kasse bei der kürzeren Schlange anstellst und es dann länger dauert, als bei allen anderen",
"Dieser Moment, wenn man sich nicht entscheiden kann was man anziehen soll obwohl man am Tag davor entschieden hat was man anziehen will",
"Dieser Moment, wenn man eine SMS bekommst, indem steht 'Ihr aktuelles Guthaben beträgt weniger als 1 Euro, bitte denken...'",
"Dieser Moment, wenn man in den Kühlschrank schaut, obwohl man weiß, dass er leer ist",
"Dieser Moment, wenn du etwas ganze bestimmtes vorhast, du dort hingehst und vergisst, was du machen wolltest",
"Dieser Moment, wenn du versuchst den Lischtschalter genau in die Mitte an- und auszimachen",
"Dieser Moment, wenn du aufs Klo gehst und plötzlich die besten Ideen bekommst",
"Dieser Moment, wenn du einen Anruf um 2 Sekunden verpasst, zurückrufst und niemand rangeht",
"Dieser Moment, wenn du in Minecraft an eine Kiste gehst und vergessen hast, was du holen wolltest",
"Dieser Moment, wenn dir jemand 'Aha' schreibt und man sich einfach nur 'Fick dich' denkt",
"Dieser Moment, wenn du nach dem haare stylen noch einen Pullover anziehen musst",
"Dieser Moment, wenn sich 2 Pädophile treffen, weil sie sich im Internet als Kinder ausgegeben haben",
"Dieser Moment, wenn man singt und alles um sich herum vergisst",
"*____________________________________________*",
":P",
":-D",
":(",
"XD",
"=)",
"=D",
"!?",
"Diese Nachricht konnte nicht gefunden werden, Oups",
"a² + b² = c²",
"1+2+3+4 = 10",
"Serverinhaber: HorrorClown",
"*-*",
"@.@",
"d-_-b",
"(d(-.-)b)",
"Die folgende Nachricht ist für User unter 18 Jahren nicht geeignet :3",
"YOLO ist eine dämliche nacherfindung von Polo!",
"Sollte der Server mal offline sein, so wählen sie 110",
"Wer das ließt, ist doof",
"HAAAAA, GAY!",
"www.mta-sa.org",
":>",
"We can see you!",
"Shup up, B@#c$?&h",
"Wenn du dich fragst, warum du das hieß ließt, könnte wir uns genauso fragen, warum wir soetwas eigentlich gescriptet haben o.o",
"Beim registrieren hast du bestätigt, dass du dich mit den Regeln im Forum vertraut gemacht hast!",
"Unwissenheit schützt vor Strafe nicht D:",
"F#@*ck you NSA!",
"www.mta-sa.org",
"Für schnellen Support, nutze /support [text]",
"Drücke 'u' für das Userpanel",
"Rekord: 103 Spieler gleichzeitig online",
"For quick support, type /support [text]",
"Wenn es zu weit weg ist, dann brauchst du es nicht",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"www.mta-sa.org",
"Serverinhaber: PewX",
"Serverinhaber: PewX",
"Serverinhaber: PewX",
"Serverinhaber: PewX",
"Serverinhaber: PewX",
"Serverinhaber: PewX",
"Serverinhaber: PewX",
"Serverinhaber: PewX",
"Serverinhaber: PewX",
"Serverinhaber: PewX",
"Serverinhaber: PewX",
"Wenn etwas unter dein Bett fällt, ist es weg. Für immer.",
"Wenn es dir niemand holt, brauchst du es nicht mehr.",
"www.mta-sa.org",
"Muss man sich das Essen vorher noch selber machen, hat man keinen Hunger.",
"Du trinkst nachts nur etwas, wenn es direkt neben dem Bett steht.",
"Ist es nicht auf der ersten Seite von Googel existiert es nicht.",
"Wenn du mit dem Staubsauger nicht rankommst ist dort schon sauber.",
"Der PC wird mit dem großen Zeh aus gemacht, nicht mit der Hand.",
"Wenn die Fernbedienung zu weit weg ist, dann wird plötzlich alles interessant was gerade läuft.",
"Hör auf selbst aufzuräumen. Ruf das Ordnungsamt an. Wozu sind die sonst da?",
"Erst 'ne Stunde aufs Ohr hauen, dann ins Bett.",
"Vermeide es zu kochen. Döner holen ist auch kochen!",
"www.mta-sa.org",
"Aufgaben so lange verschieben, bis sie entgültig vergessen werden.",
"Aufräumen muss man erst, wenn das WLAN-Signal nicht mehr durchkommt!",
"In Deutschland braucht man eine genehmigung, wenn man mehr als 150 Helium Luftballons steigen lassen will O:",
"Die einmilliardste Nachkommastelle von Pi ist eine 9",
"Es ist anatomisch unmöglich seine Ellenbogen mit der Zunge zu berühren",
"Mit Freiheitsstrafe bis zu fünf Jahren oder mit Geldstrafe wird bestraft, [...] wer eine nukleare Explosion verursacht >_>",
"1 != 2",
"Anatidaephobie ist die Angst von einer Ente beobachtet zu werden D:",
"Nachdem ein Mann auf einem Kaktus geschossen hat, 'rächte' sich dieser, indem er auf ihn fiel und ihn Tötete.",
"In China gilt Liebe als Droge",
"Der Gegenstand im Haushalt, wo die meisten Bakterien sind ist der Waschlappen",
"Die Wahrscheinlichkeit auf dem Weg zur Lotterie zu Sterben ist höher als die, im Lotto zu gewinnen",
"Sex kann durch den dabei entstehenden Schweiß Fieber senken",
"In New York ist es Frauen untersagt auf der Straße zu rauchen",
"www.mta-sa.org",
"www.mta-sa.org",
"In Los Angeles darf man nicht mit 2 Babys gleichzeitig in einer Badewanne baden",
"Der RGB-Wert der Simpsons ist 255/217/15",
"In den USA ist Alkohol trinken in den Öffentlichkeit verboten",
"Nutella hat einen Lichtschutzfaktor von 9,7",
"Alle 39 Minuten wird in Amerika ein Porno produziert",
"Wenn man sich 15 Minuten nicht bewegt, schläft man ein",
"Mehr als 83% aller Frauen in Deutschland würden für 100.000€ Ein Jahr auf Sex verzichten",
"Gähnen ist ansteckend. Alleine der Gedanke daran lässt einen Gähnen @.@",
"Jede Zigarette verkürzt das Leben um etwa 10 Minuten",
"Das anlecken einer Briefmarke kostet eine viertel Kalorie",
"Coca Cola wäre ohne Farbstoff grün",
"Der Hacker Tron konnte Binärcode fließend Lesen und Schreiben",
"Jeder Mensch isst pro Jahr ca. 12 Schaamhaare",
"Eine Pizza mit Radius z und Dicke a hat das Volumen: 'Pi*z*z*a'",
"In Daytona ist es verboten Mülleimer sexuell zu belästigen",
"www.mta-sa.org",
"Inoffizielle Mitarbeiter bei der Stasi durften ihren Decknamen frei wählen. Der Name „Judas“ war allerdings verboten",
"Was wäre ein Baum wenn er kein Baum wäre?",
"Der Rekord an versendeten WhatsApp Nachrichten innerhalb 24 Stunden, liegt bei 27 Milliarden",
"'Con' ist unter Windows ein reservierter Gerätename. Daher kann man keinen Ordner mit diesem Namen anlegen",
"Spongebob Schwammkopf ist der einzige Nickelodeon Cartoon der aus den neunziger Jahren immer noch weiter geht",
"Der Vibrator wurde ursprünglich als medizinisches Gerät gegen die sogenannte 'weibliche Hysterie' entwickelt",
"Die Dauer des sexuellen Akts beim Schwein beträgt ca. 10 bis 20, maximal 30 Minuten",
"Wenn man in der USA von einen Hochturm runterspring und so Selbstmord begeht , droht die Todes Strafe",
"Der MTA Hauptmenü-Hintergrund besteht aus 112 Kästchen",
"www.mta-sa.org",
"Auf fast jedem US-Amerikanischen Dollar, sind Rückstände von Drogen nachweisbar",
"Würde man 9 Jahre eine Kaffe Tasse anschreien. Hätte man genug Energie um sie zu erhitzen",
"Wenn man eine Ananas salzt, schmeckt sie süßer",
"99% dieser Nachrichten sind sinnlos",
"www.mta-sa.org",
"In Arizona darf man maximal 2 Dildos im Haus haben",
"11.111 * 11.111 = 123.454.321",
"www.mta-sa.org",
"Traurige Menschen neigen dazu, mehr Geld auszugeben, als glückliche",
"12% der Amerikaner verlieren ihre Jungfräulichkeit in einem Auto",
"Man verbrennt beim Kopf gegen die Wand schlagen innerhalb einer Stunde 150 Kallorien",
"In Alaska ist es verboten lebende Elche aus sich bewegenden Flugzeugen zu werfen",
}

function setRaceGuiEnabled(state)
	if state then
		addEventHandler("onClientRender", getRootElement(), drawBottom)
		addEventHandler("onClientRender", getRootElement(), drawTimeleft)
		addEventHandler("onClientHUDRender", getRootElement(), drawRadar)
	else
		removeEventHandler("onClientRender", getRootElement(), drawBottom)
		removeEventHandler("onClientRender", getRootElement(), drawTimeleft)
		removeEventHandler("onClientHUDRender", getRootElement(), drawRadar)
	end
end


function drawBottom()
    if not getElementData(g_Me, "isLogedIn") then return end
	dxDrawImage(0, (screenHeight-((40/1080)*screenHeight)), screenWidth, (48/1080)*screenHeight, "img/bottominterface.png")
	cInfosWidth = dxGetTextWidth("FPS: " .. frames .. " Hunter: " .. distanceToHunter .. " Current map: " .. currentMap .. " Next map: " .. nextMap, 1, calibri)
	dxDrawColorText("FPS: #FF5500" .. frames .. " #ffffffHunter: #FF5500" .. distanceToHunter .. " #ffffffCurrent map: #FF5500" .. currentMap .. " #ffffffNext map: #FF5500" .. nextMap, (screenWidth/2)-(cInfosWidth/2), screenHeight-lessPixel, screenWidth, screenHeight, tocolor(255, 255, 255, 255), 1, calibri)
	dxDrawColorText(infoText, xPoint, screenHeight-lessPixel2, screenWidth, screenHeight, tocolor(255, 255, 255, infoTextAlpha), 1, calibri)
end
addEventHandler("onClientRender", getRootElement(), drawBottom)

function drawTimeleft()
    if not getElementData(g_Me, "isLogedIn") then return end
	if g_drawTimeleftBool then
		dxDrawImage((screenWidth/2)-(300/2), screenHeight-((40/1080)*screenHeight)-34, 300, 34, "img/timeleft.png")
		
		local g_TimeLeftWidth = dxGetTextWidth(g_TimeLeft, 1, calibri)
		local g_TimePassedWidth = dxGetTextWidth(g_TimePassed, 1, calibri)
		dxDrawColorText(g_TimeLeft, ((screenWidth/2)-(g_TimeLeftWidth/2))+60, screenHeight-((60/1080)*screenHeight), screenWidth, screenHeight, tocolor(255, 255, 255), 1, calibri)
		dxDrawColorText(g_TimePassed, ((screenWidth/2)-(g_TimePassedWidth/2))-60, screenHeight-((60/1080)*screenHeight), screenWidth, screenHeight, tocolor(255, 255, 255), 1, calibri)
		
		dxDrawColorText("passed", ((screenWidth/2)-60)-(leftTwidth/2), screenHeight-((75/1080)*screenHeight), screenWidth, screenHeight, tocolor(255, 85, 0), 0.75, calibri)
		dxDrawColorText("left", ((screenWidth/2)+60)-(passedTwidth/2), screenHeight-((75/1080)*screenHeight), screenWidth, screenHeight, tocolor(255, 85, 0), 0.75, calibri)
		
	end
end
addEventHandler("onClientRender", getRootElement(), drawTimeleft)

function moveAnimation()
	if isMoveToRight then return end
	local xRightPoint = xPoint+cServerInfosWidth
	if xRightPoint > 0 then
		xPoint = xPoint-1
	else
		xPoint = screenWidth + 100
	end
end
addEventHandler("onClientPreRender", getRootElement(), moveAnimation)

function setText(state)
	if state then
		addEventHandler("onClientPreRender", getRootElement(), moveToRight)
		infoText = "#ffffffAuthor: #ff5500" .. Mapauthor .. " #FF0000- #ffffffLast time played: #ff5500" .. MapLastTimePlayed .. " #FF0000- #ffffffPlayed count: #ff5500" .. MapPlayedCount .. " #ff0000- #ffffffHunters reached: #ff5500" .. MapHunterReachedCount .. " #ff0000- #ffffffMap rating: #ff5500" .. MapRate .. " #ff0000- #ffffffRating times: #ff5500" .. MapRatingTimes
		cServerInfosWidth = dxGetTextWidth(removeColorCodes(infoText), 1, calibri)
		
		if isTimer(mapInfoTimer) then killTimer(mapInfoTimer) end
		mapInfoTimer = setTimer(setText, 60000, 1, false)
	else
		theEvent = addEventHandler("onClientPreRender", getRootElement(), fadeInfotextOut)
	end
end

function fadeInfotextIn()
	if not (infoTextAlpha >= 255) then
		infoTextAlpha = infoTextAlpha + 5
	else
		removeEventHandler("onClientPreRender", getRootElement(), fadeInfotextIn)

	end
end

function fadeInfotextOut()
	if not (infoTextAlpha <= 0) then
		infoTextAlpha = infoTextAlpha - 15
	else
		removeEventHandler("onClientPreRender", getRootElement(), fadeInfotextOut)
		addEventHandler("onClientPreRender", getRootElement(), fadeInfotextIn)
		infoText = tostring(table.random(infoMSGs))
		cServerInfosWidth = dxGetTextWidth(removeColorCodes(infoText), 1, calibri)
		
		if isTimer(mapInfoTimer) then killTimer(mapInfoTimer) end
		mapInfoTimer = setTimer(setText, 30000, 1, false)
	end
end



function moveToRight()
	isMoveToRight = true
	
	if xPoint < screenWidth+20 then
		xPoint = xPoint + 70
	else
		isMoveToRight = false
		removeEventHandler("onClientPreRender", getRootElement(), moveToRight)
	end
end

function sendClientMapInfo(hunterReached,mapRate,ratedTimes)
	huntersReached = hunterReached
	mapRates = mapRate
	ratedTimess = ratedTimes
end
addEvent("sendClientMapInfo",true)
addEventHandler("sendClientMapInfo",getLocalPlayer(),sendClientMapInfo)

function handleMapInfo(mapInfo)
	Mapname = mapInfo.name or "Unknown"
	Mapauthor = mapInfo.author or "Unknown"
	MapLastTimePlayed = timestampToDate(mapInfo.lastTimePlayed) or "Unknown"
	MapPlayedCount = tostring(mapInfo.playedCount or "Unknown")
	MapHunterReachedCount = huntersReached or "0"
	MapRate = mapRates or "-"
	MapRatingTimes = ratedTimess or "0"
	setText(true)
end
addEvent("onClientMapStarting",true)
addEventHandler("onClientMapStarting",getRootElement(),handleMapInfo)

function getDistanceToHunter()
	for _, e in pairs (getElementsByType ( "racepickup")) do
		local t = getElementData (e, "type")
		if t and t == "vehiclechange" then
			local v = getElementData (e,"vehicle")
			if v and tonumber(v) == 425 then
				local hunterX, hunterY, hunterZ = getElementPosition(e)
				local playerX, playerY, playerZ = getElementPosition(getSpecPlayerOrReturnMe() or getLocalPlayer())
				if playerX and playerY and playerZ then
					distanceToHunter = math.floor(getDistanceBetweenPoints3D ( playerX, playerY, playerZ, hunterX, hunterY, hunterZ ))
				end
				return
			else
				distanceToHunter = "---"
			end
		end
	end
end
addEventHandler ( 'onClientRender', getRootElement(), getDistanceToHunter)

function getSpecPlayerOrReturnMe ()
	local target = getCameraTarget()
	if target and getElementType(target) == "vehicle" then
		return getVehicleOccupant(target)
	else
		return getLocalPlayer()
	end
end

function update_client_infos(Ping,Map,Nextmap)
	currentMap = Map
	nextMap = Nextmap
end
addEvent("update_client_infos", true)
addEventHandler("update_client_infos", getRootElement(), update_client_infos)

addEventHandler("onClientRender",getRootElement(),
	function()
		if not starttick then
			starttick = getTickCount()
		end
		counter = counter + 1
		currenttick = getTickCount()
		if currenttick - starttick >= 1000 then
			frames = counter
			counter = 0
			starttick = false
		end
	end
)

function timestampToDate(stamp)
	local time = getRealTime(stamp)
	return string.format("%d %s %02d:%02d",time.monthday,month[time.month+1],time.hour,time.minute)
end

function table.random (theTable)
    return theTable[math.random (#theTable)]
end

function removeColorCodes(text)
	if text then
		return string.gsub(text, "#%x%x%x%x%x%x", "")
	else
		return "No text in function removeColorCodes"
	end
end
