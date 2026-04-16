'use client';

import { useRef, useEffect, useState } from 'react';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts';

interface StarChartProps {
  data: Array<{ snapshotDate: string; stars: number }>;
}

function useThemeColors() {
  const ref = useRef<HTMLDivElement>(null);
  const [colors, setColors] = useState({
    accent: '#00ff41',
    border: '#1a1a1a',
    muted: '#555555',
    surface: '#0a0a0a',
    foreground: '#b3b1ad',
  });

  useEffect(() => {
    if (!ref.current) return;
    const styles = getComputedStyle(ref.current);
    setColors({
      accent: styles.getPropertyValue('--accent').trim() || '#00ff41',
      border: styles.getPropertyValue('--border').trim() || '#1a1a1a',
      muted: styles.getPropertyValue('--muted').trim() || '#555555',
      surface: styles.getPropertyValue('--surface').trim() || '#0a0a0a',
      foreground: styles.getPropertyValue('--foreground').trim() || '#b3b1ad',
    });
  }, []);

  return { ref, colors };
}

export default function StarChart({ data }: StarChartProps) {
  const { ref, colors } = useThemeColors();

  if (data.length < 2) return null;

  return (
    <div className="mb-8" ref={ref}>
      <div className="text-muted text-sm mb-3">## star history</div>
      <div className="p-4 border border-border">
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={data}>
            <CartesianGrid strokeDasharray="3 3" stroke={colors.border} />
            <XAxis
              dataKey="snapshotDate"
              tick={{ fill: colors.muted, fontSize: 11 }}
              tickFormatter={(value: string) =>
                new Date(value).toLocaleDateString('en-US', {
                  month: 'short',
                  day: 'numeric',
                })
              }
            />
            <YAxis
              tick={{ fill: colors.muted, fontSize: 11 }}
              tickFormatter={(value: number) =>
                value >= 1000 ? `${(value / 1000).toFixed(1)}k` : String(value)
              }
            />
            <Tooltip
              contentStyle={{
                backgroundColor: colors.surface,
                border: `1px solid ${colors.border}`,
                borderRadius: '0',
                color: colors.foreground,
                fontFamily: 'monospace',
                fontSize: '12px',
              }}
              labelFormatter={(label) =>
                new Date(String(label)).toLocaleDateString()
              }
              formatter={(value) => [
                Number(value).toLocaleString(),
                'stars',
              ]}
            />
            <Line
              type="monotone"
              dataKey="stars"
              stroke={colors.accent}
              strokeWidth={2}
              dot={false}
            />
          </LineChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
