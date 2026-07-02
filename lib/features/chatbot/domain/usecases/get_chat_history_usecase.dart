// features/chatbot/domain/usecases/get_chat_history_usecase.dart

// El historial del chatbot es en-memoria (no hay endpoint GET /chat/history).
// Este use case existe solo para que injection_container no explote.
// El ChatProvider maneja la lista directamente.
class GetChatHistoryUseCase {
  // vacío a propósito
}