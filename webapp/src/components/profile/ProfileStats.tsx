import { FC } from "react";

import "./ProfileStats.css";

interface ProfileStatsProps {
  telegramId: number;
  dbId: number;
  language: string;
  createdAt: string;
}

export const ProfileStats: FC<ProfileStatsProps> = ({
  telegramId,
  dbId,
  language,
  createdAt
}) => {
  const stats = [
    { label: "Telegram ID", value: telegramId.toString() },
    { label: "ID в базе", value: dbId.toString() },
    { label: "Язык", value: language.toUpperCase() },
    {
      label: "В боте с",
      value: new Date(createdAt).toLocaleDateString()
    }
  ];

  return (
    <div className="profile-stats">
      {stats.map((stat) => (
        <div key={stat.label} className="profile-stats__item">
          <span className="profile-stats__label">{stat.label}</span>
          <span className="profile-stats__value">{stat.value}</span>
        </div>
      ))}
    </div>
  );
};
