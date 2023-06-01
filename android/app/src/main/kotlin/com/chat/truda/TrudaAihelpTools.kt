package com.chat.truda

import net.aihelp.config.ConversationConfig
import net.aihelp.config.enums.ConversationIntent
import net.aihelp.init.AIHelpSupport
import net.aihelp.config.UserConfig
import org.json.JSONException
import org.json.JSONObject

object TrudaAihelpTools {
    //个人中心进入客服
    fun showConversation(map: Map<*, *>) {
        val userId = map["userId"] as String?
        val nickname = map["nickname"] as String?
        val level = map["level"] as Int
        val created = map["created"] as Int
        // 0 个人中心  1 会话列表
        val entranceType = map["entranceType"] as Int
        val conversationBuilder = ConversationConfig.Builder()
        conversationBuilder.setAlwaysShowHumanSupportButtonInBotPage(true)
        conversationBuilder.setConversationIntent(ConversationIntent.BOT_SUPPORT)
        setUserInfo(getEntrance(entranceType), userId, nickname, level, created, null)
        AIHelpSupport.showConversation(conversationBuilder.build())
    }

    /**
     *  0 个人中心  1 会话列表
     * 获取进入type
     */
    private fun getEntrance(entranceType: Int): String {
        return when (entranceType) {
            1 -> "Message"
            else -> "mine"
        }
    }


    //订单进入客服
    fun showOrderConversation(map: Map<*, *>) {
        val userId = map["userId"] as String?
        val nickname = map["nickname"] as String?
        val level = map["level"] as Int
        val created = map["created"] as Int
        val orderInfo = map["orderInfo"] as String?
        val conversationBuilder = ConversationConfig.Builder()
        conversationBuilder.setAlwaysShowHumanSupportButtonInBotPage(true)
        conversationBuilder.setConversationIntent(ConversationIntent.BOT_SUPPORT)
        setUserInfo("order", userId, nickname, level, created, orderInfo)
        AIHelpSupport.showConversation(conversationBuilder.build())
    }

    private fun setUserInfo(
        entrance: String,
        userId: String?,
        nickname: String?,
        level: Int,
        created: Int,
        orderInfo: String?
    ) {
        val customData = JSONObject()
        try {
            customData.put("level", level)
            customData.put("isCreated", created)
            if (orderInfo != null) {
                customData.put("orderInfo", orderInfo)
            }
        } catch (e: JSONException) {
            e.printStackTrace()
        }
        val userConfig = UserConfig.Builder()
            .setUserId(userId)
            .setUserName(nickname)
            .setUserTags("level:$level,$entrance")
            .setCustomData(customData.toString())
            .build()
        AIHelpSupport.updateUserInfo(userConfig)
    }
}