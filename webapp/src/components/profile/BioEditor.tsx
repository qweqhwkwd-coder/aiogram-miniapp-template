import { FC, useCallback, useState } from "react";

import { useTelegram } from "../../hooks/useTelegram";
import "./BioEditor.css";

interface BioEditorProps {
  bio: string | null;
  onSave: (bio: string) => Promise<void>;
  maxLength?: number;
}

export const BioEditor: FC<BioEditorProps> = ({
  bio,
  onSave,
  maxLength = 500
}) => {
  const [value, setValue] = useState(bio || "");
  const [isEditing, setIsEditing] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const { hapticFeedback } = useTelegram();

  const handleSave = useCallback(async () => {
    setIsSaving(true);
    try {
      await onSave(value);
      hapticFeedback("success");
      setIsEditing(false);
    } catch {
      hapticFeedback("error");
    } finally {
      setIsSaving(false);
    }
  }, [value, onSave, hapticFeedback]);

  const handleCancel = useCallback(() => {
    setValue(bio || "");
    setIsEditing(false);
  }, [bio]);

  return (
    <div className="bio-editor">
      <div className="bio-editor__header">
        <h3 className="bio-editor__title">О себе</h3>
        {!isEditing && (
          <button
            className="bio-editor__edit-btn"
            onClick={() => setIsEditing(true)}
          >
            Изменить
          </button>
        )}
      </div>

      {isEditing ? (
        <div className="bio-editor__form">
          <textarea
            className="bio-editor__textarea"
            value={value}
            onChange={(e) => setValue(e.target.value)}
            placeholder="Расскажите о себе..."
            maxLength={maxLength}
            rows={4}
          />
          <div className="bio-editor__footer">
            <span className="bio-editor__counter">
              {value.length}/{maxLength}
            </span>
            <div className="bio-editor__actions">
              <button
                className="bio-editor__btn bio-editor__btn--cancel"
                onClick={handleCancel}
                disabled={isSaving}
              >
                Отмена
              </button>
              <button
                className="bio-editor__btn bio-editor__btn--save"
                onClick={handleSave}
                disabled={isSaving}
              >
                {isSaving ? "Сохранение..." : "Сохранить"}
              </button>
            </div>
          </div>
        </div>
      ) : (
        <p className="bio-editor__text">{bio || "Биография не указана"}</p>
      )}
    </div>
  );
};
