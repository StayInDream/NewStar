
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1

-- display FPS stats on screen
DEBUG_FPS = true

-- dump memory info every 10 seconds
DEBUG_MEM = false

-- load deprecated API
LOAD_DEPRECATED_API = false

-- load shortcodes API
LOAD_SHORTCODES_API = true

-- screen orientation
CONFIG_SCREEN_ORIENTATION = "portrait"

-- design resolution
CONFIG_SCREEN_WIDTH  = 480
CONFIG_SCREEN_HEIGHT = 800

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH" --"SHOW_ALL"
--CONFIG_SCREEN_AUTOSCALE = "SHOW_ALL"

GAME_SOUND = {
    Eff_GameOver  = "sound/Eff_GameOver.mp3",
    Eff_GetItem   = "sound/Eff_GetItem.mp3",
	Eff_Warning   = "sound/Eff_Warning.mp3",
	advbg         = "sound/advbg.mp3",
	classicbg     = "sound/classicbg.mp3",
	pclear        = "sound/pclear.mp3",
	pgetcoin      = "sound/pgetcoin.mp3",
	planding      = "sound/planding.mp3",
	ppop          = "sound/ppop.mp3",
	pselect       = "sound/pselect.mp3",
	pstar         = "sound/pstar.mp3",
	ptarget       = "sound/ptarget.mp3",
	word_1        = "sound/word_1.mp3",
	word_2        = "sound/word_2.mp3",
	fireworks_01  = "sound/fireworks_01.mp3",
	fireworks_02  = "sound/fireworks_02.mp3",
	fireworks_03  = "sound/fireworks_03.mp3",
	NextGameRound = "sound/NextGameRound.mp3",
	Props_Bomb    = "sound/Props_Bomb.mp3",
	Props_Paint   = "sound/Props_Paint.mp3",
	Props_Rainbow = "sound/Props_Rainbow.mp3",
	gameover      ="sound/gameover.mp3",
}

GAME_IMAGE = {
	Bg_Stage          = "image/Bg_Stage.jpg",
	btn_email         = "image/btn_email.png",
	Button_Shop       = "image/Button_Shop.png",
	coin_bar          = "image/coin_bar.png",
	CDKEY_btn         = "image/CDKEY_btn.png",
	emailIcon_diamond = "image/emailIcon_diamond.png",
	emailIcon_gold    = "image/emailIcon_gold.png",
	front             = "image/front.jpg",
	sp_continue       = "image/file_symbol.png",
	sp_relife         = "image/file_symbol1.png", --可复活
	jinbi_tiao        = "image/jinbi_tiao.png",
	logo_xin_1        = "image/logo_xin_1.png",
	logo_pic          = "image/logo_pic.png",
	menu_btn          = "image/menu_btn.png",
	paihangbang       = "image/paihangbang.png",
	pause             = "image/pause.png",
	popstar_continue  = "image/popstar_continue.png",
	popstar_start     = "image/popstar_start.png",
	trqunrukou        = "image/trqunrukou.png",
	jiahao            = "image/jiahao.png",
	Props_Bomb        = "image/Props_Bomb.png",
	Props_Paint       = "image/Props_Paint.png",
	Props_Rainbow     = "image/Props_Rainbow.png",
    stage_clear       = "image/stage_clear.png",
    stage_clear_bg    = "image/stage_clear_bg.png",
    dangqianfenshu    = "image/dangqianfenshu.png",
	praise0           = "image/beautiful.png", 
	praise00          = "image/god.png", 
	praise1           = "image/praise5.png", 
	praise2           = "image/praise8.png", 
	praise3           = "image/praise10.png", 
	praise4           = "image/praise12.png", 
	praise5           = "image/praise18.png", 
	praise6           = "image/praise25.png", 
	praise7           = "image/jingdai.png",
	btnBg             = "image/11db.png",
	btnFrame          = "image/XSdk.png",
	Button_Continue   = "image/Button_Continue_0.png",
	Button_Home       = "image/Button_Home_0.png",
	Button_SoundOff   = "image/Button_SoundOff_0.png",
	Button_SoundOn    = "image/Button_SoundOn_0.png",
	jiazai            = "image/jiazai.png",
	jsy               = "image/jsy.png",
	connected         = "image/connected.png",
	connected_not     = "image/connected_not.png",
	close_bg          = "image/gb.png",
	sp_mask           = "image/JLdb.png",  --黑色遮罩
	jixutongguan      = "image/jixutongguan.png", 
	jixutongguan_juese= "image/jixutongguan_juese.png", 
	tongguananniu_btn = "image/tongguananniu.png", 
	tongguananniu_wenzi= "image/tongguananniu_wenzi.png", 
	result_bg1         = "image/result_bg1.png", 
	retry              = "image/retry.png", 
	bg_sunburst1       = "image/bg_sunburst1.png", 
	exit               = "image/exit.png",
	buydiamand_wenzi   = "image/150diamand.png",
	anniu              = "image/anniu.png",
	anniu1             = "image/anniu1.png",
	zengbig_unicom     = "image/zengbig_unicom.png",
	hotsale_bg         =  "image/hotsale_bg.png",
	onsale_btn_buy     =  "image/onsale_btn_buy.png",
	onsale_btn_huode   =  "image/onsale_btn_huode.png",
	onsale_btn_lingqu  =  "image/onsale_btn_lingqu.png",
	for_bg             =  "image/9for_bg.png",
	set_about          =  "image/set_about.png",
	set_back           =  "image/set_back.png",
	shangdian_biaotoutu=  "image/shangdian_biaotoutu.png",
	shangdian_wenzi    =  "image/shangdian_wenzi.png",
	shop_item_bg_1     =  "image/shop_item_bg-1.png",
	shop_item_bg_2     =  "image/shop_item_bg-2.png",
	huodong_diban_2    =  "image/huodong_diban_2.png",
	duanxinzhifu_2     =  "image/duanxinzhifu-2.png",
	sk_gift_tgjl       =  "image/sk_gift_tgjl.png",
	gift_btn           =  "image/gift_btn.png",
	dalibao_mm         = "image/dalibao_mm.png",
	lijihuode          = "image/lijihuode.png",
	wenzimiaoshu       = "image/wenzimiaoshu.png",
	zengsong_xin       = "image/zengsong_xin.png",
	x500               = "image/x500.png",
	Text_StageEnd      = "image/Text_StageEnd.png",
	Text_StageEnd02    = "image/Text_StageEnd02.png",
	Bg_PanelPause      = "image/Bg_PanelPause.png",
	title_silk         = "image/title_silk.png",
	title_silk_22      = "image/title_silk_22.png",
	title_silk_zise    = "image/title_silk_zise.png",
	hengfu             = "image/hengfu.png",
	Sign_ComboX        = "image/Sign_ComboX.png",
	emailIcon_activity = "image/emailIcon_activity.png",
	huodongzhongxin    = "image/huodongzhongxin.png",
	no_activity        = "image/no_activity.png",
	onsale_btn_1       = "image/onsale_btn_1.png",
	zengtubeijing      = "image/zengtubeijing.png",
	biaoti             = "image/biaoti.png",
} 

GAME_PARTICE = {
	pop_star1000_particle      = "particle/pop_star1000.plist",
	pop_star1001_particle      = "particle/pop_star1001.plist",
	pop_star1002_particle      = "particle/pop_star1002.plist",
	pop_star1003_particle      = "particle/pop_star1003.plist",
	pop_star1004_particle      = "particle/pop_star1004.plist",
	pop_star1100_particle      = "particle/pop_star1100.plist",
	pop_star1101_particle      = "particle/pop_star1101.plist",
	pop_star1102_particle      = "particle/pop_star1102.plist",
	pop_star1103_particle      = "particle/pop_star1103.plist",
	pop_star1104_particle      = "particle/pop_star1104.plist",

	Particle_Star              = "particle/poptile/Particle_Star.plist",
	Particle_TileDebris        = "particle/poptile/fireworks1.plist",
}

GAME_FONT_ =  "c23.fnt" 

GAME_TEXTURE_DATA_FILENAME  = "popstar.plist"
GAME_TEXTURE_IMAGE_FILENAME = "popstar.png"