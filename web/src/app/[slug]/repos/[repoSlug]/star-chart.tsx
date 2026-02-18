'use client';

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

export default function StarChart({ data }: StarChartProps) {
  if (data.length < 2) return null;

  return (
    <div className="mb-8">
      <div className="text-muted text-sm mb-3">## star history</div>
      <div className="p-4 border border-border">
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={data}>
            <CartesianGrid strokeDasharray="3 3" stroke="#1a1a1a" />
            <XAxis
              dataKey="snapshotDate"
              tick={{ fill: '#555555', fontSize: 11 }}
              tickFormatter={(value: string) =>
                new Date(value).toLocaleDateString('en-US', {
                  month: 'short',
                  day: 'numeric',
                })
              }
            />
            <YAxis
              tick={{ fill: '#555555', fontSize: 11 }}
              tickFormatter={(value: number) =>
                value >= 1000 ? `${(value / 1000).toFixed(1)}k` : String(value)
              }
            />
            <Tooltip
              contentStyle={{
                backgroundColor: '#0a0a0a',
                border: '1px solid #1a1a1a',
                borderRadius: '0',
                color: '#b3b1ad',
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
              stroke="#00ff41"
              strokeWidth={2}
              dot={false}
            />
          </LineChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
