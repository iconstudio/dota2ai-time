local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func')
local ConversionMode = dofile( GetScriptDirectory()..'/AuxiliaryScript/BotlibConversion') --引入技能文件
local Minion = dofile( GetScriptDirectory()..'/FunLib/Minion')
local sTalentList = J.Skill.GetTalentList(bot)
local sAbilityList = J.Skill.GetAbilityList(bot)

--编组技能、天赋、装备
local tGroupedDataList = {
	{
		--组合说明，不影响游戏
		['info'] = 'By Misunderstand',
		--天赋树
		['Talent'] = {
			['t25'] = {10, 0},
			['t20'] = {10, 0},
			['t15'] = {10, 0},
			['t10'] = {10, 0},
		},
		--技能
		['Ability'] = { 1, 2, 3, 3, 3, 6, 3, 1, 1, 1, 6, 2, 2, 2, 6 },
		--装备
		['Buy'] = {
			"item_tango",
			"item_gauntlets",
			"item_double_branches",
			"item_magic_stick",
			"item_flask",
			"item_soul_ring",
			"item_magic_wand",
			"item_phase_boots",
			"item_blink",
			"item_cyclone",
			"item_ultimate_scepter",
			"item_black_king_bar", 
			"item_heart",
			"item_invis_sword",
			"item_ultimate_scepter_2",
			"item_silver_edge",
			"item_travel_boots_2",
			"item_moon_shard"
		},
		--出售
		['Sell'] = {

			"item_black_king_bar",  
			"item_magic_wand",	  

			"item_heart",
			"item_soul_ring",

			"item_travel_boots_2",
			"item_phase_boots",
		},
	},
}
--默认数据
local tDefaultGroupedData = {
	['Talent'] = {
		['t25'] = {10, 0},
		['t20'] = {0, 10},
		['t15'] = {10, 0},
		['t10'] = {0, 10},
	},
	['Ability'] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
	['Buy'] = {
		'item_tango',
		'item_flask',
		'item_double_branches',
		'item_enchanted_mango',
		'item_clarity',
		'item_energy_booster',
		'item_recipe_magic_wand',
		'item_blink',
		'item_recipe_force_staff',
		'item_wind_lace',
		'item_blade_of_alacrity',
		'item_recipe_greater_crit'
	},
	['Sell'] = {
		"item_crimson_guard",
		"item_quelling_blade",
	}
}

--根据组数据生成技能、天赋、装备
local nAbilityBuildList, nTalentBuildList;

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = ConversionMode.Combination(tGroupedDataList, tDefaultGroupedData)

nAbilityBuildList,nTalentBuildList,X['sBuyList'],X['sSellList'] = J.SetUserHeroInit(nAbilityBuildList,nTalentBuildList,X['sBuyList'],X['sSellList']);

X['sSkillList'] = J.Skill.GetSkillList(sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList)

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = true

function X.MinionThink(hMinionUnit)

	if Minion.IsValidUnit(hMinionUnit) 
	then
		if hMinionUnit:IsIllusion() 
		then 
			Minion.IllusionThink(hMinionUnit)	
		end
	end

end


function X.SkillsComplement()

	--如果当前英雄无法使用技能或英雄处于隐形状态，则不做操作。
	if J.CanNotUseAbility(bot) or bot:IsInvisible() then return end
	--技能检查顺序
	local order = {'R','W','Q'}
	--委托技能处理函数接管
	if ConversionMode.Skills(order) then return; end

end

return X